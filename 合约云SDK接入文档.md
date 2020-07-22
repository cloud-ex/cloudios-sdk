合约云SDK接入文档
====

# 1.0 兼容性
支持 iOS10.0 以上的系统。其他系统需要进行测试。 

# 1.1 软硬件支持 
    1.硬件: iPhone。
    2.开发环境: Xcode10.13 及以上版本。 

# 2.0 合约SDK功能介绍
    
## 1.公有信息数据（SLPublicSwapInfo）
    市场Ticker 
    深度OrderBook
    最新成交Trade
    K线Kline 
## 2.个人账户信息数据（SLPersonaSwapInfo）
    合约资产
    合约仓位
    委托订单
    订单记录
## 3.ws数据实时刷新（SLSocketDataManager）
    行情、深度、最新成交 订阅跟取消
    私有资产订阅需要通过认证（认证成功SDK内部自动订阅）

# 3.0 集成SDK
## 1.将SDK包中的SLContractSDK.framework SLContractSDK.bundle拖入到到工程（后续添加到pod中）
    SLContractSDK.framework  主文件
    SLContractSDK.bundle     接口路径配置
## 2 pod 添加
    pod ‘SocketRocket’
    Pod ‘Reachaility’
# 3.1 导入头文件
    #import <SLContractSDK/SLContractSDK.h>
# 4.0 初始化SDK
## 1.程序启动时候初始化 SLSDK
###  sl_startWithAppID:launchOption:callBack: 
| 参数 | 类型 | 说明|
| -------|:-----:|:-----:|
|AppID| String |不可为空，传入app名称即可(预留字段，只做了非空校验)|
|base_host| String |合约云环境域名（按Demo中填写即可）|
|base_Header| String |合约云环境请求头（按Demo中的填写即可）|
|headers| Dictionary |需要另外加入请求头中的信息|
|isSwapCloud |BOOL|是否是合约云用户传YES|
-------

## 2.登录成功后初始化 SLPlatformSDK
### sl_startWithAccountInfo 
| 参数 | 类型 | 说明|
| -------|:-----:|:-----:|
|Uid |String|如果没有, 可以不传|
|Token |String|接入方自己后台接入成功后从后台获取|
|access_key |String| 合约云用接入方申请生成的access_key|
|expiredTs |String|客户端从接入方自己后台获取到的expired_ts,单位是微秒|
--------

## 3.ws初始化建立连接
    sdk初始化之后建立ws链接：
    SLContractSocketManager.shared().srWebSocketOpen(withURLString: "合约ws链接")

# 5.0 合约市场
## Rest api
| SLSDK方法 | 功能 |  调用(建议)  |
| ---------|:-----:|---------:|
|sl_startWithAppID:launchOption:callBack:|初始化合约SDK| 在程序起来的时候调用|
|sl_loadFutureMarketData| 获取合约市场Ticker |  初始化SDK成功可获取合约列表|
|sl_loadFutureLatestDealWithContractID：callbackData| 根据合约id获取合约最新成交 | 根据需求调用|
|sl_loadFutureDepthWithContractID | 根据合约id获取合约深度 | 根据需求调用|
|sl_loadRiskReservesWithContractID|根据合约id获取保险基金记录|根据需求调用|
|sl_loadFundingrateWithContractID|根据合约id获取资金费率|根据需求调用|
|sl_loadFutureKLineDataWithContractID|请求合约K线数据|根据需求调用|

## WS
|SLSocketDataManager|功能|调用|
| ---------|:-----:|---------:|
|sl_subscribeContractTickerData| 订阅市场实时ticket | restApi获取到市场ticker之后订阅，前台生命周期内不需要取消订阅|
|sl_subscribeContractDepthDataWithInstrument|根据合约id订阅合约深度 socket| 进入合约交易页面或者详情页订阅合约深度|
|sl_unSubscribeContractDepthDataWithInstrument|根据合约id取消订阅合约深度 socket| 离开合约交易页面或者K线详情页取消订阅，切换订阅时不需要取消，sdk内部做了取消处理|
|sl_subscribeContractTradeDataWithInstrument|根据合约id订阅最新成交|进入合约K线详情页订阅|
|sl_unSubscribeContractTradeDataWithInstrument|根据合约id取消订阅最新成交|离开合约K线详情页取消订阅|
|sl_subscribeQuoteBinDataWithContractID|根据合约id合K线时间间隔类型订阅K线|进入合约K线详情页通过restapi请求成功后订阅|
|sl_subscribeUnicastData|订阅合约私有资产|登录成功之后调用|

# 6.0 合约交易

## 1. SLPlatformSDK类中数据接口需要在传入 activeAccount 初始化之后调用
## 2. 合约交易请求接口数据模型
    BTContractTool 	类中有所有的合约交易的请求接口

    BTContract 		            合约基本信息模型
    BTContractFeeConfigModel    合约手续费模型
    BTContractRiskLimitModel    合约风险限额模型
    BTContractsModel 		    合约信息数据模型
    BTContractsOpenModel 	    合约开仓数据模型
    BTContractRecordModel 	    合约交易记录模型
    BTContractOrderModel        合约订单模型
    BTCashBooksModel		    资金流水模型
    BTPositionModel             合约仓位模型

## 3. 合约交易流程
### 1> 请求合约资产（sl_loadUserContractPerpotyCallBack）
    通过请求合约资产判断合约资产是否为空数组[]判断是否开通合约
    如果开通则会返回对应保证金币种的数据模型 BTItemCoinModel
### 2> 开通合约 (createContractAccountWithContractID)
    根据合约ID开通合约，开通合约之后请求合约资产数组
### 3> 合约开通之后才可以进行资金划转（接入方后台自己提供资金划转接口）
    资金划转成功之后请求合约资产接口（或通过ws推送）
### 4> 合约有足够资产后可创建合约订单交易
    1.创建合约开仓订单 BTContractOrderModel.newContractOpenOrder
    2.创建合约平仓订单 BTContractOrderModel.newContractCloseOrder

    3.提交合约订单 BTContractTool.sendContractsOrder
    4.取消合约订单 BTContractTool.cancelContractOrders

    5.获取委托列表 BTContractTool.getUserContractOrders(status为3当前委托，4为历史委托)

    6.根据合约id获取持仓列表 BTContractTool.getUserPositionWithContractID(status为3当前仓位，4为历史仓位)
    7.根据保证金币获取持仓列表 BTContractTool.getUserPositionWithcoinCode(status为3当前仓位，4为历史仓位)
    ........

    注意：登录之后所有的下单请求及记录都在BTContractTool中

# 7.0 websocket接入附加提示
    1.一定在在restAPI 获取到合约ticker列表之后才能订阅合约ticker
    2.ticker可全程订阅不需要取消，因为大多计算都需要实时价格或者合理价格
    3.进入交易页面或者合约详情页才需要订阅合约深度，离开则取消（深度一秒推20次左右）
    4.登录之后确保token有效之后才可以订阅私有资产
    5.app进入后台之后需要断开ws，进入前台之后重新连接，在每个合约页面监听ws连接成功的状态，然后订阅该页面需要订阅的数据


# 8.0 SDK接入注意
    1.一定要在SLSDK初始化之后进行操作
    2.一定要在SLPlatFormSDK初始化之后才可以进行交易操作
    3.登录之后请求合约资产后没有获得对应保证金币种的合约需要去开通，开通划转资金后才可以进行下单操作
    4.需要登录才能请求的api返回forbbiden说明token失效，这个时候sdk内部会清空登录信息发送通知，监听这个通知，将登录状态置为未登录
    5.SLPersonaSwapInfo可根据需求获取个人信息数据且实时更新

# 9.0 新增止盈止损功能
    1. 根据 SLContractPlanProfitOrlossType 枚举，判定获取到的计划委托是否是止盈止损委托
    2. createPlanProfitOrLossOrderWithContractId 创建止盈止损单
    3. BTContractTool.submitProfitOrLossOrder  提交止盈止损单
    4. BTContractTool.cancelProfitOrLossOrder  取消止盈止损单

    注意：当为止盈止损单子的时候数量显示100%
