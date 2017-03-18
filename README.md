# SLTableView
`UITableView`是开发中经常用到的控制之一，但是每次实现起来都是大同小异。特别是`UITableViewDelegate ` 和`UITableViewDataSource ` 这两个协议基本每次都是粘贴复制。再者加上实现加载数据，下拉刷新以及上拉加载更多等逻辑代码，那么在控制器中的代码量就会很大，对于后期的维护和后来者看代码加大了难度。其实可以把`UITableView`模块化。

#####人狠话不多,直接来：

首先我们来看`UITableViewDataSource ` ，常用的代理方法如下：
```
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section

```
前面两个方法是代理中必须实现的，后面的是经常用到的。

#####分割数据源
考虑到代理中必须返回`row`以及`cell`。然后这里我们还要考虑到多个`section`的情况，所以这里数据源需要是一个二维数组，数组装的是`sectionModel`：
```
@interface SLTableViewSectionModel : NSObject

/// UITableDataSource 协议中的 titleForHeaderInSection 方法可能会用到
@property (nonatomic, copy) NSString *headerTitle;

/// UITableDataSource 协议中的 titleForFooterInSection 方法可能会用到
@property (nonatomic, copy) NSString *footerTitle;

/// 数据model数组
@property (nonatomic, strong) NSMutableArray *listModels;

- (instancetype)initWithModelArray:(NSMutableArray *)listModels;

@end
```
看到这个对象里面有一个`listModels`，它是一个数组，里面是每行`cell`对应的`model`数据，所以我们还需要一个基类`BaseListModel`：
```
@interface SLBaseListModel : NSObject
//子类需要添加数据model属性
///cell 高度
@property (nonatomic, assign) CGFloat cellHeight;

///初始化model 需要在子类重写
- (instancetype)initWithData:(NSDictionary *)data;

@end
```
创建`cell`数据model的时候，需要继承上面的类，这样方面后面通过model类型返回对应的`cell class`。

数据类型被统一了，那么我们就可以创建一个`UITableViewDataSource `基类：
```
///cell block 用于传递cell的按钮点击事件
typedef void (^SLTableViewCellBlock)(id cell, id item);


@protocol LslTableVDataSource <UITableViewDataSource>

@optional

//方便tableview delegate 调用以下方法 和 子类重写
- (SLBaseListModel *)tableView:(UITableView *)tableView objectForRowAtIndexPath:(NSIndexPath *)indexPath;

- (Class)tableView:(UITableView *)tableView cellClassForObject:(SLBaseListModel *)model;

@end

@interface SLTableViewDataSouce : NSObject
<
LslTableVDataSource
>

///section 二维数组
@property (nonatomic, strong) NSMutableArray    *sections;

///cell block
@property (nonatomic, copy) SLTableViewCellBlock CellBlock;


- (instancetype)initWithCellBlock:(SLTableViewCellBlock)cBlock;

- (void)clearAllModel;

///普通table 一个section 添加数据listModel
- (void)nomalAppendModel:(NSArray *)models;

///多个section 组合好了的数据model  直接赋值给sections
```
我们可以直接在基类里面实现`UITableViewDataSource `的方法：
```
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sections ? [self.sections count] : 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section < [self.sections count]) {
        SLTableViewSectionModel *sectionModel = self.sections[section];
        return [sectionModel.listModels count];
    }
    return 0;
}
```
下面我们再看看返回`cell`的实现方法：
```
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SLBaseListModel *listModel = [self tableView:tableView objectForRowAtIndexPath:indexPath];
    
    Class class = [self tableView:tableView cellClassForObject:listModel];
    
    NSString *className = [NSString stringWithUTF8String:class_getName(class)];
    SLBaseTableViewCell *cell = (SLBaseTableViewCell *)[tableView dequeueReusableCellWithIdentifier:className];
    if (!cell) {
        cell = [[class alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:className];
    }
    
    //初始化cell数据
    [cell initWithData:listModel];
    
    
    if (self.CellBlock) {
        self.CellBlock(cell,listModel);
    }
    return cell;
}
```
上面的实现主要是通过`indexPath `找到对应的`listModel`，然后通过`listModel`找到对应的`cell`。就是方法：
```
- (SLBaseListModel *)tableView:(UITableView *)tableView objectForRowAtIndexPath:(NSIndexPath *)indexPath;

- (Class)tableView:(UITableView *)tableView cellClassForObject:(SLBaseListModel *)model;
```
可以看到这两个方法是写在`protocol`里面的，并且继承自`UITableViewDataSource `,这样是为什么呢？`- (instancetype)initWithCellBlock:(SLTableViewCellBlock)cBlock`这个方法又是干什么的呢？后面会讲，继续往下看。

#####分割代理
代理里面最重要的也就是返回`cell`高度：
```
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath ;
```

首先我们首先需要创建个`controller`:
```
@interface SLBaseTableViewController : UIViewController
<
UITableViewDelegate
>

/// UITableView
@property (nonatomic, strong) UITableView       *baseTableView;

/// UITableViewStyle 默认 UITableViewStylePlain
@property (nonatomic, assign) UITableViewStyle  tableViewStyle;

/// 分割线 默认 UITableViewCellSeparatorStyleSingleLine
@property (nonatomic, assign) UITableViewCellSeparatorStyle tableViewCellSeparatorStyle;

/// 背景色 默认白色
@property (nonatomic, strong) UIColor           *tableViewBackgroundColor;

/// header 默认nil
@property (nonatomic, strong) UIView            *headerView;

/// footer 默认nil
@property (nonatomic, strong) UIView            *footerView;

///SLTableViewDataSouce
@property (nonatomic, strong) SLTableViewDataSouce   *dataSource;

/// 加载更多view
@property (nonatomic, strong) SLTableLoadMoreView    *loadMoreView;

/// 是否拥有下拉刷新 默认 NO
@property (nonatomic, assign) BOOL               bNeedRefreshAction;

/// 是否拥有上拉加载更多 默认 NO
@property (nonatomic, assign) BOOL               bNeedLoadMoreAction;

/// 是否刷新加载数据 默认 NO
@property (nonatomic, assign) BOOL               bRefresh;


/// 设置table
- (void)createTableView;

/// 设置TableDatasource
- (void)initTableDatasource;

/// 初始化下拉刷新
- (void)initMJRefresh;

/// 初始化上拉加载
- (void)initLoadMore;

/// 刷新加载数据
- (void)beginRefresh;

/// 加载更多数据
- (void)loadMoreData;
```
这个类里面添加了`tableView`，属性以及刷新、加载更多方法。我们还是来一步一步的看实现吧：
```
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //获取table datasource
    id<LslTableVDataSource> dataSource = (id<LslTableVDataSource>)tableView.dataSource;
    
    SLBaseListModel *listModel = [dataSource tableView:tableView objectForRowAtIndexPath:indexPath];
    Class cls = [dataSource tableView:tableView cellClassForObject:listModel];
    
    if (listModel.cellHeight == 0.0f) { // 没有高度缓存
        listModel.cellHeight = [cls cellHeight:listModel];
    }
    return listModel.cellHeight;
}

```
这个方法实现通过`datasource`调用到方法，找到对应的cell 返回高度。这里把`cell`的高度计算放到了`cell`中，这样可以减少控制器的代码量以及优化`tableView`。

`cell`点击：
```
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    id<LslTableVDataSource> dataSource = (id<LslTableVDataSource>)tableView.dataSource;
    
    SLBaseListModel *listModel = [dataSource tableView:tableView objectForRowAtIndexPath:indexPath];
    
    [self clickedTableCell:listModel];
    
}
```
看看`- (instancetype)initWithCellBlock:(SLTableViewCellBlock)cBlock`这个方法是干什么的：
```
    __weak typeof(self) weakSelf = self;
    SLTableViewCellBlock cellBlock = ^(DemoTableViewCell *cell, DemoListModel *model) {
        //可以遍历cell上的按钮 将按钮事件传递到控制器
        [weakSelf forCellBtn:cell];
        
    };

- (void)forCellBtn:(DemoTableViewCell *)cell {
    for (UIView *view in cell.contentView.subviews ) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)view;
            [btn addTarget:self action:@selector(clickedCellBtn:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
}

- (void)clickedCellBtn:(UIButton *)btn {
    //处理点击事件
    NSLog(@">>>clicked cell btn");
}
```
当然最重要的是：
```
self.baseTableView.dataSource = self.dataSource;
```

#####分割网络加载
我们先搞一个基类：
```
@protocol ListRequestDelegate <NSObject>

///请求数据成功
- (void)requestDidSuccess:(NSArray *)listModels loadMore:(BOOL)bHaveMoreData;

///请求失败
- (void)requestDidFail:(NSDictionary *)error;

@end

@interface SLBaseTableListRequest : SLBaseRequest

///接口路径
@property (nonatomic, copy) NSString    *dataPath;

///页数 默认1
@property (nonatomic, assign) NSUInteger currentPage;

///每页条数 默认10
@property (nonatomic, assign) NSUInteger rows;

///请求代理
@property (nonatomic, weak) id<ListRequestDelegate> delegate;


///加载数据
- (void)loadData:(BOOL)bRefresh;


@end

```
.m主要实现
```
- (void)loadData:(BOOL)bRefresh {
    [super loadData:bRefresh];
    if (bRefresh) {
        self.currentPage = 1;
    } else {
        self.currentPage ++;
    }
    
    [self loadData];
}

- (void)loadData {
    
    __weak typeof (self) weakSelf = self;
    
    [AFNetHttpManager postWithUrl:[self requestUrl] params:[self requestAllArgument] success:^(id result) {
        
        [weakSelf dicToModel:result[@"tngou"]];
        
    } fail:^(NSDictionary *errorInfo) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(requestDidFail:)]) {
            [self.delegate requestDidFail:errorInfo];
        }
    }];
}

- (void)dicToModel:(NSArray *)list {
    NSMutableArray *listModel = [[NSMutableArray alloc] init];
    for (NSDictionary *dic in list) {
        DemoListModel *model = [[DemoListModel alloc] initWithData:dic];
        [listModel addObject:model];
    }
    
    BOOL bMore = NO;
    if ([list count] == self.rows) {
        bMore = YES;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(requestDidSuccess:loadMore:)]) {
        [self.delegate requestDidSuccess:listModel loadMore:bMore];
    }
    
}
```
这样在控制器中只需要实现代理：
```
- (void)requestDidSuccess:(NSArray *)listModels loadMore:(BOOL)bHaveMoreData
- (void)requestDidFail:(NSString *)error 
```
就OK了。
吃个🌰：
```
- (void)beginRefresh {
    self.bRefresh = YES;
    [self.loadMoreView stopLoadMore];
    [self.listRequst loadData:self.bRefresh];
}

- (void)loadMoreData {
    self.bRefresh = NO;
    [self.loadMoreView startLoadMore];
    [self.baseTableView.mj_header endRefreshing];
    [self.listRequst loadData:self.bRefresh];
}
- (void)requestDidSuccess:(NSArray *)listModels loadMore:(BOOL)bHaveMoreData {
    //请求 数据成功
    //如果是刷新，清除之前的数据
    if (self.bRefresh) {
        [self.dataSource clearAllModel];
        [self.baseTableView.mj_header endRefreshing];
        
        if (bHaveMoreData && self.bNeedLoadMoreAction) {
            //添加加载更多
            [self initLoadMore];
        } else {
            self.baseTableView.tableFooterView = [UIView new];
        }
    } else {
        //加载更多
        [self.loadMoreView stopLoadMore];
    }
    
    [self.dataSource nomalAppendModel:listModels];
    
    [self.baseTableView reloadData];
}

- (void)requestDidFail:(NSString *)error {
    
    //请求 数据失败
    [self.baseTableView.mj_header endRefreshing];
    [self.loadMoreView stopLoadMore];
}
```
实现了table的下拉刷新和加载更多数据，看着是不是比没分割之前的代码清爽得一逼。虽然整体的代码量并没减少多少，但是分割之后看着鼻子是鼻子，眼睛是眼睛，这样才是一个正常的人。
(其实还有很多`tableView`功能可以进行分割，比如：`cell`的编辑，也不复杂！有兴趣的老铁可以试试)

###代码不分多少，只分思想。

详情见 Demo：[SLTableView](https://www.baidu.com)
如果你觉得对你有用，请star！

以上仅限个人愚见，欢迎吐槽！

参考：@bestswifter [如何写好一个UITableView](http://www.jianshu.com/p/504c61a9dc82)

后续有时间会写`tableView`高度自适应的文章，欢迎关注！
