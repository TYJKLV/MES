/**
 * 这是模型的静态常量配置
 * 和货架的配置（一般要从数据库读取，这里仅做演示）
 * @author 谢宁, Created on 2020-01-07
 */
/** ***************************************************************** */

var PLANE_LENGTH = 24;  //货架板面长度
var PLANE_WIDTH = 55;   //货架板面宽度
var PLANE_HEIGHT = 2;   //货架板面高度
var HOLDER_LENGTH = 2;  //支架长度
var HOLDER_WIDTH = 2;   //支架宽度
var HOLDER_HEIGHT = 25; //支架高度
var LAYER_NUM = 3;      //货架层数
var COLUMN_NUM = 2;     //货架每层列数
var BOX_SIZE = 16;      //货物的大小(立方体)

//货架数组（由3DProject.ftl动态填充）
var shelf_list = new Array();

function GET_PLANE_LENGTH(){
  return PLANE_LENGTH;
}

function GET_PLANE_WIDTH(){
  return PLANE_WIDTH;
}

function GET_PLANE_HEIGHT(){
  return PLANE_HEIGHT;
}

function GET_HOLDER_LENGTH(){
  return HOLDER_LENGTH;
}

function GET_HOLDER_WIDTH(){
  return HOLDER_WIDTH;
}

function GET_HOLDER_HEIGHT(){
  return HOLDER_HEIGHT;
}

function GET_LAYER_NUM(){
  return LAYER_NUM;
}

function GET_COLUMN_NUM(){
  return COLUMN_NUM;
}

function GET_BOX_SIZE(){
  return BOX_SIZE;
}

function GET_SHELF_LIST(){
  return shelf_list;
}
