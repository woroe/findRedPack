//
//  CircleViewController.m
//  zhubo
//
//  Created by Jin on 2017/6/8.
//  Copyright © 2017年 重庆步联科技. All rights reserved.
//

#import "CircleViewController.h"
#import "CircleModel.h"
#import "CircleGridView.h"
#import "CircleDetailViewController.h"

#import "CircleCreatViewController.h"

#import "searchViewController.h"

@interface CircleViewController ()<UISearchBarDelegate, UICollectionViewDataSource, UICollectionViewDelegate,CircleCreatViewControllerDelegate,searchViewControllerDelegate>{
    
    UIView *searchTabView;
}

@property(nonatomic, strong) UISearchBar *searchBar;

@property(nonatomic, strong) NSMutableArray <CircleModel *>*models;

//UICollectionView
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *customLayout;
@property (nonatomic, assign) CGFloat collctionCellW;

@end

static NSString *collcellId = @"collectionViewID";
@implementation CircleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.models = [NSMutableArray array];
    [self loadUI];
    [self loadData];
}
-(void)viewWillAppear:(BOOL)animated{
    [self loadData];
}
- (void)loadUI {
    self.title = @"圈子";
    
    
    CGRect searchFrame = CGRectMake(15, 7.5, self.view.bounds.size.width - 30, 28);
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:searchFrame];
    searchBar.searchBarStyle = UISearchBarStyleMinimal;
    searchBar.placeholder = @"搜索圈子";
    searchBar.delegate = self;
    [self.view addSubview:searchBar];
    self.searchBar = searchBar;
    
    
    //collectionView
    self.collctionCellW = (SCREEN_WIDTH - 2*MARGIN_30 - 10 * SCREEN_W_SCALE ) / 2;
    CGRect collFrame = CGRectMake(MARGIN_30, searchFrame.size.height + MARGIN_30, SCREEN_WIDTH - 2*MARGIN_30, SCREEN_HEIGHT-64-50-searchFrame.size.height-20);
    _customLayout = [[UICollectionViewFlowLayout alloc] init];
    // 自定义的布局对象
    _customLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    _customLayout.minimumLineSpacing = 10 * SCREEN_W_SCALE;
    _customLayout.minimumInteritemSpacing = 10 * SCREEN_W_SCALE;
    _collectionView = [[UICollectionView alloc] initWithFrame:collFrame collectionViewLayout:_customLayout];
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:collcellId];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.contentSize = CGSizeMake(0, 5000);
    self.collectionView.alwaysBounceVertical = YES;
    [self.view addSubview:_collectionView];
    
    _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadData];
    }];
    _collectionView.mj_footer = [MJRefreshBackFooter footerWithRefreshingBlock:^{
    }];
    [_collectionView.mj_header beginRefreshing];
}

#pragma mark -- UISearchBarDelegate
//cancel按钮点击时调用
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self searchData: _searchBar.text];
    [self.view removeFromSuperview];
    [self loadUI];
    [self.searchBar resignFirstResponder];
}
//点击搜索框时调用
- (void) searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    searchViewController *entranceVC = [[searchViewController alloc] init];
    entranceVC.delegate = self;
    [entranceVC setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    //背景透明
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0) {
        entranceVC.modalPresentationStyle=UIModalPresentationOverCurrentContext;
    }else{
        self.modalPresentationStyle=UIModalPresentationCurrentContext;
    }
    
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:entranceVC animated:YES completion:^{
    }];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.searchBar resignFirstResponder];
    [_searchBar resignFirstResponder];
}
- (void)closeKeyBoard {
    if(self.searchBar.isFirstResponder) {
        [self.searchBar resignFirstResponder];
        [self.searchBar resignFirstResponder];
    }
}
- (void)loadData {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"UserId"] = @([BaseData shareInstance].userId);
    params[@"BuildSowingType"] = @"BuildSowing_SelectMyCircle";
    
    [[AFHTTPSessionManager manager] POST:httpurl parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *res = (NSDictionary *)responseObject;
        if([[res objectForKey:@"StatusCode"] isEqual:@(1)]){
            ZBLog(@"BuildSowing_SelectMyCircle--%@", res);
            
            NSArray *dataArr = [res objectForKey:@"data"];
            if(!dataArr || dataArr.count == 0) {
                [self.collectionView.mj_header endRefreshing];
                return ;
            }
            [self.models removeAllObjects];
            for (NSDictionary *data in dataArr) {
                CircleModel *model = [[CircleModel alloc] initWithDictionary:data];
                [self.models addObject:model];
            }
            _customLayout.itemSize = CGSizeMake(_collctionCellW, _collctionCellW);
            [self.collectionView.mj_header endRefreshing];
            [self.collectionView reloadData];
        }
        else{
            [self.collectionView.mj_header endRefreshing];
            [SVProgressHUD showErrorWithStatus:BaseStringNetError];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.collectionView.mj_header endRefreshing];
        [SVProgressHUD showErrorWithStatus:BaseStringNetError];
    }];
}

- (void)searchData:(NSString *)keyWords {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"UserId"] = @([BaseData shareInstance].userId);
    params[@"BuildSowingType"] = @"BuildSowing_SelectCircle";
    params[@"Name"] = keyWords;
    
    [[AFHTTPSessionManager manager] POST:httpurl parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *res = (NSDictionary *)responseObject;
        if([[res objectForKey:@"StatusCode"] isEqual:@(1)]){
            ZBLog(@"BuildSowing_SelectCircle--%@", res);
            
            NSArray *dataArr = [res objectForKey:@"data"];
            if(!dataArr || dataArr.count == 0) {
                return ;
            }
            [self.models removeAllObjects];
            for (NSDictionary *data in dataArr) {
                CircleModel *model = [[CircleModel alloc] initWithDictionary:data];
                [self.models addObject:model];
            }
            [self.collectionView reloadData];
        }
        else{
            [SVProgressHUD showErrorWithStatus:BaseStringNetError];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:BaseStringNetError];
    }];
}

#pragma mark - UICollectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.models.count + 1;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [_collectionView dequeueReusableCellWithReuseIdentifier:collcellId forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    [cell.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if(indexPath.row == self.models.count) {
        CGFloat w = 130*SCREEN_W_SCALE;
        CGFloat x = (self.collctionCellW - w) / 2;
        UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(x, 35*SCREEN_W_SCALE, w, w)];
        [view setImage:[UIImage imageNamed:@"cjqz"]];
        [cell addSubview:view];
        
        UILabel *titLab = [[UILabel alloc] initWithFrame:CGRectMake(0, w + 75*SCREEN_W_SCALE, self.collctionCellW, 30 * SCREEN_W_SCALE)];
        titLab.text = @"创建圈子";
        titLab.textAlignment = NSTextAlignmentCenter;
        titLab.textColor = BaseColorGray;
        titLab.font = [UIFont systemFontOfSize:30 *SCREEN_W_SCALE];
        [cell addSubview: titLab];
    }else {
        CircleGridView *view = [[CircleGridView alloc] initWithFrame:CGRectMake(0, 0, self.collctionCellW, self.collctionCellW)];
        [view loadWithModel:self.models[indexPath.row]];
        [cell addSubview:view];
    }
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == self.models.count) {
     
        CircleCreatViewController *creatVC = [[CircleCreatViewController alloc] init];
        creatVC.delegate = self;
        [self.navigationController pushViewController:creatVC animated:YES];
        return;
    }
    CircleDetailViewController *detailVC = [[CircleDetailViewController alloc] init];
    detailVC.model = self.models[indexPath.row];
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark - CircleCreatViewControllerDelegate
-(void)CircleOKRead{
    [self loadData];
}

#pragma mark -- searchViewControllerDelegate
-(void)FbNewsCircle:(CircleModel *)sender{
    
    CircleDetailViewController *detailVC = [[CircleDetailViewController alloc] init];
    detailVC.model = sender;
    [self.navigationController pushViewController:detailVC animated:YES];
    
}

@end
