/**
 *  界面导航路由
 *  通过openURL方式打开界面，起到解耦效果
 *  应用场景：不同组件调用界面
 *  不适用场景：组件内部请避免滥用
 *
 *  流程：
 *  被调用方，在+(void)load方法中 将可以被调起的界面进行注册，将URL与类进行关联
 *  调用方，通过openURL请求打开界面
 *  ONERoute，根据约定规则进行处理
 *
 *  必要方法：
 *  被调用方，必须实现-(instancetype)init; 可选-(void)routeModuleSetParams:(NSDictionary *)params
 *  调用方:可以将参数直接附在链接后面，也可以在NSURL调用setONERouteURLParams: 添加参数
 */