package cn.mryt.sxws.mryt_share_plugin.bean

/**
 * @ Description: 返回结果信息Bean
 * @ Author: 樊磊
 * @ Email:fanlei01@missfresh.cn
 * @ CreateDate: 2019-09-19 15:03
 */

data class ResultInfoBean(var success: Boolean = true, var method: String? = "", var operational: String? = "", var msg: String? = "") {

    /**
     * @param success       结果
     * @param method        方法
     * @param operational   操作
     * @param msg           信息
     */

    override fun toString(): String {
        return "{\"success\":$success,\"method\":\"$method\",\"operational\":\"$operational\",\"msg\":\"$msg\"}"
    }
}
