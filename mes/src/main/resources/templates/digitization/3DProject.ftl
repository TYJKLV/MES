<!DOCTYPE html>
<html>
<head includeDefault="true">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, user-scalable=no, minimum-scale=1.0, maximum-scale=1.0">
    <title>3D数字仿真</title>
    <style>
        body {
            margin: 0;
            overflow: hidden;
        }

        #label {
            position: absolute;
            padding: 10px;
            background: rgba(255, 255, 255, 0.6);
            line-height: 1;
            border-radius: 5px;
        }

        #video {
            position: absolute;
            width: 0;
            height: 0;
        }
    </style>

    <script type="text/javascript" src="${request.contextPath}/lib/ThreeJs/js/three.js"></script>
    <script type="text/javascript" src="${request.contextPath}/lib/ThreeJs/js/stats.min.js"></script>
    <script type="text/javascript" src="${request.contextPath}/lib/ThreeJs/js/DragControls.js"></script>
    <script type="text/javascript" src="${request.contextPath}/lib/ThreeJs/js/OrbitControls.js"></script>
    <script type="text/javascript" src="${request.contextPath}/lib/ThreeJs/js/FirstPersonControls.js"></script>
    <script type="text/javascript" src="${request.contextPath}/lib/ThreeJs/js/TransformControls.js"></script>
    <script type="text/javascript" src="${request.contextPath}/lib/ThreeJs/js/dat.gui.min.js"></script>
    <script type="text/javascript" src="${request.contextPath}/lib/ThreeJs/js/EffectComposer.js"></script>
    <script type="text/javascript" src="${request.contextPath}/lib/ThreeJs/js/RenderPass.js"></script>
    <script type="text/javascript" src="${request.contextPath}/lib/ThreeJs/js/OutlinePass.js"></script>
    <script type="text/javascript" src="${request.contextPath}/lib/ThreeJs/js/FXAAShader.js"></script>
    <script type="text/javascript" src="${request.contextPath}/lib/ThreeJs/js/CopyShader.js"></script>
    <script type="text/javascript" src="${request.contextPath}/lib/ThreeJs/js/ShaderPass.js"></script>
    <script type="text/javascript" src="${request.contextPath}/lib/ThreeJs/js/ThreeBSP.js"></script>
    <script type="text/javascript" src="${request.contextPath}/lib/ThreeJs/ThreeJs_Drag.js" charset="UTF-8"></script>
    <script type="text/javascript" src="${request.contextPath}/lib/ThreeJs/ThreeJs_Composer.js"
            charset="UTF-8"></script>
    <script type="text/javascript" src="${request.contextPath}/lib/ThreeJs/Modules.js" charset="UTF-8"></script>
    <script type="text/javascript" src="${request.contextPath}/lib/ThreeJs/js/Tween.js"></script>
    <script type="text/javascript" src="${request.contextPath}/lib/jquery/jquery.min.js"></script>
    <script type="text/javascript" src="${request.contextPath}/lib/echarts/echarts.min.js"></script>
    <script type="text/javascript" src="${request.contextPath}/lib/ThreeJs/config.js"></script>
</head>

<body>
<div id="label"></div>
<div id="container"></div>
<video id="video" autoplay loop muted>
    <source src="${request.contextPath}/video/videoPlane.mp4">
</video>

<script>

    var stats = initStats();
    var scene, camera, renderer, controls, light, composer, transformControls, options;
    var matArrayA = []; //内墙
    var matArrayB = []; //外墙
    var group = new THREE.Group();
    var isPaused = false;

    // 初始化场景
    function initScene() {
        scene = new THREE.Scene();
    }

    // 初始化相机
    function initCamera() {
        camera = new THREE.PerspectiveCamera(45, window.innerWidth / window.innerHeight, 0.1, 10000);
        camera.position.set(0, 50, 200);
    }

    // 初始化灯光
    function initLight() {
        var directionalLight = new THREE.DirectionalLight(0xffffff, 0.3); //模拟远处类似太阳的光源
        directionalLight.color.setHSL(0.1, 1, 0.95);
        directionalLight.position.set(0, 200, 0).normalize();
        scene.add(directionalLight);

        var ambient = new THREE.AmbientLight(0xffffff, 1); //AmbientLight,影响整个场景的光源
        ambient.position.set(0, 0, 0);
        scene.add(ambient);
    }

    // 初始化性能插件
    function initStats() {
        var stats = new Stats();

        stats.domElement.style.position = 'absolute';
        stats.domElement.style.left = '0px';
        stats.domElement.style.top = '0px';

        document.body.appendChild(stats.domElement);
        return stats;
    }

    // 初始化GUI
    function initGui() {
        options = new function () {
            this.batchNo = '';
            this.qty = 0;
            this.qtyUom = '';
            this.qty2 = 0;
            this.实时全景监控 = function () {
                window.open("3DVideo.html");
            };
        };
        var gui = new dat.GUI();
        gui.domElement.style = 'position:absolute;top:10px;right:0px;height:600px';
        gui.add(options, 'batchNo').name("物料批号：").listen();
        gui.add(options, 'qty').name("数量：").listen();
        gui.add(options, 'qtyUom').name("单位：").listen();
        gui.add(options, 'qty2').name("件数：").listen();
        gui.add(options, '实时全景监控');
    }

    // 初始化渲染器
    function initRenderer() {
        renderer = new THREE.WebGLRenderer({
            antialias: true
        });
        renderer.setSize(window.innerWidth, window.innerHeight);
        renderer.setClearColor(0x4682B4, 1.0);
        document.body.appendChild(renderer.domElement);
    }

    //创建地板
    function createFloor() {
        var loader = new THREE.TextureLoader();
        loader.load("/lib/ThreeJs/images/floor.jpg", function (texture) {
            texture.wrapS = texture.wrapT = THREE.RepeatWrapping;
            texture.repeat.set(10, 10);
            var floorGeometry = new THREE.BoxGeometry(2600, 1400, 1);
            var floorMaterial = new THREE.MeshBasicMaterial({
                map: texture,
            });
            var floor = new THREE.Mesh(floorGeometry, floorMaterial);
            floor.rotation.x = -Math.PI / 2;
            floor.name = "地面";
            scene.add(floor);
        });
    }

    //创建墙
    function createCubeWall(width, height, depth, angle, material, x, y, z, name) {
        var cubeGeometry = new THREE.BoxGeometry(width, height, depth);
        var cube = new THREE.Mesh(cubeGeometry, material);
        cube.position.x = x;
        cube.position.y = y;
        cube.position.z = z;
        cube.rotation.y += angle * Math.PI; //-逆时针旋转,+顺时针
        cube.name = name;
        scene.add(cube);
    }

    //创建门_左侧
    function createDoor_left(width, height, depth, angle, x, y, z, name) {
        var loader = new THREE.TextureLoader();
        loader.load("/lib/ThreeJs/images/door_left.png", function (texture) {
            var doorgeometry = new THREE.BoxGeometry(width, height, depth);
            doorgeometry.translate(50, 0, 0);
            var doormaterial = new THREE.MeshBasicMaterial({
                map: texture,
                color: 0xffffff
            });
            doormaterial.opacity = 1.0;
            doormaterial.transparent = true;
            var door = new THREE.Mesh(doorgeometry, doormaterial);
            door.position.set(x, y, z);
            door.rotation.y += angle * Math.PI; //-逆时针旋转,+顺时针
            door.name = name;
            scene.add(door);
        });
    }

    //创建门_右侧
    function createDoor_right(width, height, depth, angle, x, y, z, name) {
        var loader = new THREE.TextureLoader();
        loader.load("/lib/ThreeJs/images/door_right.png", function (texture) {
            var doorgeometry = new THREE.BoxGeometry(width, height, depth);
            doorgeometry.translate(-50, 0, 0);
            var doormaterial = new THREE.MeshBasicMaterial({
                map: texture,
                color: 0xffffff
            });
            doormaterial.opacity = 1.0;
            doormaterial.transparent = true;
            var door = new THREE.Mesh(doorgeometry, doormaterial);
            door.position.set(x, y, z);
            door.rotation.y += angle * Math.PI; //-逆时针旋转,+顺时针8
            door.name = name;
            scene.add(door);
        });
    }

    //创建窗户
    function createWindow(width, height, depth, angle, x, y, z, name) {
        var loader = new THREE.TextureLoader();
        loader.load("/lib/ThreeJs/images/window.png", function (texture) {
            var windowgeometry = new THREE.BoxGeometry(width, height, depth);
            var windowmaterial = new THREE.MeshBasicMaterial({
                map: texture,
                color: 0xffffff
            });
            windowmaterial.opacity = 1.0;
            windowmaterial.transparent = true;
            var windows = new THREE.Mesh(windowgeometry, windowmaterial);
            windows.position.set(x, y, z);
            windows.rotation.y += angle * Math.PI; //-逆时针旋转,+顺时针
            windows.name = name;
            scene.add(windows);
        });
    }

    //返回墙对象
    function returnWallObject(width, height, depth, angle, material, x, y, z, name) {
        var cubeGeometry = new THREE.BoxGeometry(width, height, depth);
        var cube = new THREE.Mesh(cubeGeometry, material);
        cube.position.x = x;
        cube.position.y = y;
        cube.position.z = z;
        cube.rotation.y += angle * Math.PI;
        cube.name = name;
        return cube;
    }

    //墙上挖门，通过两个几何体生成BSP对象
    function createResultBsp(bsp, objects_cube) {
        var material = new THREE.MeshPhongMaterial({
            color: 0x9cb2d1,
            specular: 0x9cb2d1,
            shininess: 30,
            transparent: true,
            opacity: 1
        });
        var BSP = new ThreeBSP(bsp);
        for (var i = 0; i < objects_cube.length; i++) {
            var less_bsp = new ThreeBSP(objects_cube[i]);
            BSP = BSP.subtract(less_bsp);
        }
        var result = BSP.toMesh(material);
        result.material.flatshading = THREE.FlatShading;
        result.geometry.computeFaceNormals(); //重新计算几何体侧面法向量
        result.geometry.computeVertexNormals();
        result.material.needsUpdate = true; //更新纹理
        result.geometry.buffersNeedUpdate = true;
        result.geometry.uvsNeedUpdate = true;
        scene.add(result);
    }

    //创建墙纹理
    function createWallMaterail() {
        matArrayA.push(new THREE.MeshPhongMaterial({color: 0xafc0ca}));  //前  0xafc0ca :灰色
        matArrayA.push(new THREE.MeshPhongMaterial({color: 0xafc0ca}));  //后
        matArrayA.push(new THREE.MeshPhongMaterial({color: 0xd6e4ec}));  //上  0xd6e4ec： 偏白色
        matArrayA.push(new THREE.MeshPhongMaterial({color: 0xd6e4ec}));  //下
        matArrayA.push(new THREE.MeshPhongMaterial({color: 0xafc0ca}));  //左    0xafc0ca :灰色
        matArrayA.push(new THREE.MeshPhongMaterial({color: 0xafc0ca}));  //右

        matArrayB.push(new THREE.MeshPhongMaterial({color: 0xafc0ca}));  //前  0xafc0ca :灰色
        matArrayB.push(new THREE.MeshPhongMaterial({color: 0x9cb2d1}));  //后  0x9cb2d1：淡紫
        matArrayB.push(new THREE.MeshPhongMaterial({color: 0xd6e4ec}));  //上  0xd6e4ec： 偏白色
        matArrayB.push(new THREE.MeshPhongMaterial({color: 0xd6e4ec}));  //下
        matArrayB.push(new THREE.MeshPhongMaterial({color: 0xafc0ca}));  //左   0xafc0ca :灰色
        matArrayB.push(new THREE.MeshPhongMaterial({color: 0xafc0ca}));  //右
    }


    // 初始化模型
    function initContent() {
        createFloor();
        createWallMaterail();
        createCubeWall(10, 200, 1400, 0, matArrayB, -1295, 100, 0, "墙面");
        createCubeWall(10, 200, 1400, 1, matArrayB, 1295, 100, 0, "墙面");
        createCubeWall(10, 200, 2600, 1.5, matArrayB, 0, 100, -700, "墙面");
        //创建挖了门的墙
        var wall = returnWallObject(2600, 200, 10, 0, matArrayB, 0, 100, 700, "墙面");
        var door_cube1 = returnWallObject(200, 180, 10, 0, matArrayB, -600, 90, 700, "前门1");
        var door_cube2 = returnWallObject(200, 180, 10, 0, matArrayB, 600, 90, 700, "前门2");
        var window_cube1 = returnWallObject(100, 100, 10, 0, matArrayB, -900, 90, 700, "窗户1");
        var window_cube2 = returnWallObject(100, 100, 10, 0, matArrayB, 900, 90, 700, "窗户2");
        var window_cube3 = returnWallObject(100, 100, 10, 0, matArrayB, -200, 90, 700, "窗户3");
        var window_cube4 = returnWallObject(100, 100, 10, 0, matArrayB, 200, 90, 700, "窗户4");
        var objects_cube = [];
        objects_cube.push(door_cube1);
        objects_cube.push(door_cube2);
        objects_cube.push(window_cube1);
        objects_cube.push(window_cube2);
        objects_cube.push(window_cube3);
        objects_cube.push(window_cube4);
        createResultBsp(wall, objects_cube);
        //为墙面安装门
        createDoor_left(100, 180, 2, 0, -700, 90, 700, "左门1");
        createDoor_right(100, 180, 2, 0, -500, 90, 700, "右门1");
        createDoor_left(100, 180, 2, 0, 500, 90, 700, "左门2");
        createDoor_right(100, 180, 2, 0, 700, 90, 700, "右门2");
        //为墙面安装窗户
        createWindow(100, 100, 2, 0, -900, 90, 700, "窗户");
        createWindow(100, 100, 2, 0, 900, 90, 700, "窗户");
        createWindow(100, 100, 2, 0, -200, 90, 700, "窗户");
        createWindow(100, 100, 2, 0, 200, 90, 700, "窗户");
    }

    // 初始化轨迹球控件
    function initControls() {
        controls = new THREE.OrbitControls(camera, renderer.domElement);
        controls.enableDamping = true;
        controls.dampingFactor = 0.5;
        // 视角最小距离
        controls.minDistance = 100;
        // 视角最远距离
        controls.maxDistance = 1000;
        // 最大角度
        controls.maxPolarAngle = Math.PI / 2.2;
        controls.target = new THREE.Vector3(50, 50, 0);
    }

    // 动态生成ECharts（基于实际库房数据）
    function initEchartsDynamic(warehouses) {
        // 从实际库房数据中提取名称和库位数
        var whNames = [];
        var whLocCounts = [];
        var pieData = [];
        if (warehouses && warehouses.length > 0) {
            for (var i = 0; i < warehouses.length; i++) {
                var name = warehouses[i].warehouseName || ('库房' + (i + 1));
                var locCount = (warehouses[i].locations || []).length;
                whNames.push(name);
                whLocCounts.push(locCount);
                pieData.push({value: locCount, name: name});
            }
        } else {
            whNames = ['暂无数据'];
            whLocCounts = [0];
            pieData = [{value: 1, name: '暂无数据'}];
        }

        // 柱状图：各库房库位数量对比
        var barChart = echarts.init($("<canvas width='512' height='512'></canvas>")[0]);
        barChart.setOption({
            color: ['#3398DB'],
            tooltip: {trigger: 'axis', axisPointer: {type: 'shadow'}},
            grid: {left: '3%', right: '4%', bottom: '3%', containLabel: true},
            xAxis: [{type: 'category', data: whNames, axisTick: {alignWithLabel: true}}],
            yAxis: [{type: 'value', name: '库位数'}],
            series: [{name: '库位数', type: 'bar', barWidth: '60%', data: whLocCounts}]
        });

        barChart.on('finished', function () {
            var barTexture = new THREE.TextureLoader().load(barChart.getDataURL());
            var barMaterial = new THREE.MeshBasicMaterial({
                transparent: true, map: barTexture, side: THREE.DoubleSide
            });
            var barPlane = new THREE.Mesh(new THREE.PlaneGeometry(100, 100), barMaterial);
            // 放在仓库前方墙壁上方，避免与库区重叠
            barPlane.position.set(200, 180, -685);
            scene.add(barPlane);
        });

        // 饼图：各库房库位占比分布
        var pieChart = echarts.init($("<canvas width='512' height='512'></canvas>")[0]);
        pieChart.setOption({
            title: {text: '库房库位分布', subtext: 'MES数据', x: 'center'},
            tooltip: {trigger: 'item', formatter: "{a} <br/>{b} : {c} ({d}%)"},
            legend: {orient: 'vertical', left: 'left', data: whNames},
            series: [{
                name: '库位分布',
                type: 'pie',
                radius: '55%',
                center: ['50%', '60%'],
                data: pieData,
                itemStyle: {
                    emphasis: {shadowBlur: 10, shadowOffsetX: 0, shadowColor: 'rgba(0, 0, 0, 0.5)'}
                }
            }]
        });

        pieChart.on('finished', function () {
            var pieTexture = new THREE.TextureLoader().load(pieChart.getDataURL());
            var pieMaterial = new THREE.SpriteMaterial({
                transparent: true, map: pieTexture, side: THREE.DoubleSide
            });
            var pieSprite = new THREE.Sprite(pieMaterial);
            pieSprite.scale.set(150, 150, 1);
            // 放在仓库前方墙壁上方，避免与库区重叠
            pieSprite.position.set(-200, 180, -685);
            scene.add(pieSprite);
        });
    }

    // 初始化静态场景后，动态加载库房库位数据
    function init() {
        initMat();
        initScene();
        addSkybox(10000, scene);
        addVideoPlane(0, 60, -690, 200, 100, scene, 'video');
        initCamera();
        initRenderer();
        initContent();
        initLight();
        initControls();
        initGui();

        // 从数据库加载库房库位数据，动态构建3D场景（含ECharts初始化）
        loadWarehouseData();
    }

    function loadWarehouseData() {
        $.ajax({
            url: '${request.contextPath}/basedata/warehouse/3d-data',
            type: 'GET',
            success: function (response) {
                var warehouses = response.data || [];

                // 清空config.js的硬编码数据
                shelf_list.length = 0;

                if (warehouses.length === 0) {
                    addArea(0, 0, 1000, 500, scene, "empty$暂无库房数据", "999999", 20, "居中");
                    initPostProcess();
                    initEchartsDynamic([]);
                    return;
                }

                // 仓库建筑内部可用空间: x∈[-1250,1250] (宽约2500), z∈[-650,650] (深约1300)
                // 多库房沿x轴排列（建筑宽度方向），避免穿墙
                var areaLength = 450;
                var warehouseCount = warehouses.length;
                var areaWidth = Math.min(800, 2300 / warehouseCount - 80);
                var shelfBaseY = GET_HOLDER_HEIGHT()/2 + GET_PLANE_HEIGHT()/2; // 货架底部贴合地板

                var spacingX = 60;
                var totalWidth = warehouseCount * areaWidth + (warehouseCount - 1) * spacingX;
                var startX = -totalWidth / 2 + areaWidth / 2;

                for (var w = 0; w < warehouses.length; w++) {
                    var wh = warehouses[w];
                    var areaX = startX + w * (areaWidth + spacingX);
                    var locs = wh.locations || [];
                    var locCount = locs.length;

                    // 绘制库区（所有库区在同一z平面，沿x轴分布）
                    addArea(areaX, 0, areaWidth, areaLength, scene,
                        wh.warehouseId + "$" + wh.warehouseName, "FF0000", 20, "居中");

                    // 为每个库位创建货架配置（在库区内x方向居中排列）
                    for (var l = 0; l < locCount; l++) {
                        shelf_list.push({
                            StorageZoneId: wh.warehouseId,
                            shelfId: locs[l].id,
                            shelfName: locs[l].code,
                            x: areaX + l * 100 - (locCount - 1) * 50,
                            y: shelfBaseY,
                            z: 0
                        });
                    }
                }

                // 渲染货架和货物
                if (shelf_list.length > 0) {
                    addShelf(scene);
                    for (var i = 1; i <= GET_LAYER_NUM(); i++) {
                        for (var j = 1; j <= GET_COLUMN_NUM(); j++) {
                            for (var k = 0; k < shelf_list.length; k++) {
                                addOneUnitCargos(shelf_list[k].shelfId, i, j, scene);
                            }
                        }
                    }
                }

                initPostProcess();
                initEchartsDynamic(warehouses);
            },
            error: function () {
                addArea(0, 0, 1000, 500, scene, "error$数据加载失败", "FF0000", 20, "居中");
                initPostProcess();
            }
        });
    }

    function initPostProcess() {
        //添加选中时的蒙版
        composer = new THREE.ThreeJs_Composer(renderer, scene, camera, options, []);

        //添加拖动效果
        var objects = [];
        for (var i = 0; i < scene.children.length; i++) {
            var Msg = scene.children[i].name.split("$");
            if (scene.children[i].isMesh && Msg[0] == "货物") {
                objects.push(scene.children[i]);
            }
        }

        var dragControls = new THREE.DragControls(objects, camera, renderer.domElement);
        dragControls.addEventListener('dragstart', function (event) {
            controls.enabled = false;
            isPaused = true;
        });
        dragControls.addEventListener('dragend', function (event) {
            controls.enabled = true;
            isPaused = false;
        });

        document.addEventListener('resize', onWindowResize, false);
    }

    // 窗口变动触发的方法
    function onWindowResize() {
        camera.aspect = window.innerWidth / window.innerHeight;
        camera.updateProjectionMatrix();
        renderer.setSize(window.innerWidth, window.innerHeight);
    }

    function animate() {
        requestAnimationFrame(animate);
        renderer.render(scene, camera);
        composer.render();
        update();
    }

    // 更新控件
    function update() {
        stats.update();
        controls.update();
        TWEEN.update();
        RollTexture.offset.x += 0.001;
    }

    init();
    animate();
</script>
</body>

</html>
