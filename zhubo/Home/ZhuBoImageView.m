//
//  ZhuBoImageView.m
//  zhubo
//
//  Created by Jin on 2017/6/15.
//  Copyright © 2017年 重庆步联科技. All rights reserved.
//

#import "ZhuBoImageView.h"

#import "ZYTagImageView.h"
#import "ZYTagInfo.h"
#import "ZYTagView.h"
#import "HZPhotoBrowser.h"

#import "JZLPhotoBrowser.h"


@interface ZhuBoImageView()<HZPhotoBrowserDelegate>



@end

@implementation ZhuBoImageView

- (void)drawRect:(CGRect)rect {
    // Drawing code
}

- (void)loadWithModel:(ZhuBoModel *)model delegate:(id)delegate type:(NSInteger)type{
    _model = model;
    _delegate = delegate;
    
    if(!model.newsContent){
        return;
    }
    
    self.backgroundColor = [UIColor whiteColor];
    if(_model.newsContentType == 2){
        [self loadVideoView];
    }
    else{
        [self loadImageView:type];
    }
}
#pragma mark -- 视频播放
- (void)loadVideoView {
    
    UIImageView *img = [self imageWith:self.frame url:_model.FirstImsg index:0];
    [self addSubview:img];
    
}
- (void)loadImageView:(NSInteger)type {
    if(_model.imgArr.count == 1){
        
        NSString *imgArrStr0 = _model.imgArr[0];
        NSArray *arr0 = [imgArrStr0 componentsSeparatedByString:@","];
        
        NSString *ulrStr ;
        for (NSString *str in arr0) {
            if (str.length > 6) {
                ulrStr =str;
            }
        }
        UIImageView *img = [self imageWith:self.frame url:ulrStr index:0];
        [self addSubview:img];
    }
    else if(_model.imgArr.count == 2){
        CGFloat imgWidth = self.frame.size.width / 2 - 2;
        CGRect frame1 = CGRectMake(0, 0, imgWidth, self.frame.size.height);
        NSString *imgArrStr0 = _model.imgArr[0];
        NSArray *arr0 = [imgArrStr0 componentsSeparatedByString:@","];
        NSString *ulrStr ;
        for (NSString *str in arr0) {
            if (str.length > 6) {
                ulrStr =str;
            }
        }
        UIImageView *img1 = [self imageWith:frame1 url:ulrStr index:0];
        [self addSubview:img1];
        
        CGRect frame2 = CGRectMake(imgWidth + 4, 0, imgWidth, self.frame.size.height);
        NSString *imgArrStr = _model.imgArr[1];
        NSArray *arr = [imgArrStr componentsSeparatedByString:@","];
        NSString *ulrStr1 ;
        for (NSString *str in arr) {
            if (str.length > 6) {
                ulrStr1 =str;
            }
        }
        UIImageView *img2 = [self imageWith:frame2 url:ulrStr1 index:1];
        [self addSubview:img2];
    }else {
        //正文页九宫格展示
        if(type == -1){
            CGFloat imgW = (self.frame.size.width - 8) / 3;
            for(NSInteger index = 0; index < _model.imgArr.count; index++){
                CGFloat x = ( index % 3 ) * ( imgW + 4 );
                CGFloat y = ( (NSInteger)index / 3 ) * ( imgW + 4 );
                CGRect frame = CGRectMake(x, y, imgW, imgW);
                NSString *imgArrStr = _model.imgArr[index];
                NSArray *arr = [imgArrStr componentsSeparatedByString:@","];
                NSString *ulrStr1 ;
                for (NSString *str in arr) {
                    if (str.length > 6) {
                        ulrStr1 =str;
                    }
                }
                UIImageView *img = [self imageWith:frame url:ulrStr1 index:index];
                [self addSubview:img];
            }
            
            CGRect selfFrame = self.frame;
            NSInteger lines = (NSInteger)ceil(_model.imgArr.count / 3.0 );
            selfFrame.size.height = imgW * lines + ( lines - 1 ) * 4;
            self.frame = selfFrame;
            
            return;
        }
        
        CGFloat rightImgWidth = (self.frame.size.height - 4) / 2;
        CGFloat leftImgWidth = self.frame.size.width - rightImgWidth - 2;
        CGRect frame1 = CGRectMake(0, 0, leftImgWidth, self.frame.size.height);
        NSString *imgArrStr = _model.imgArr[0];
        NSArray *arr = [imgArrStr componentsSeparatedByString:@","];
        NSString *ulrStr1 ;
        for (NSString *str in arr) {
            if (str.length > 6) {
                ulrStr1 =str;
            }
        }
        UIImageView *img1 = [self imageWith:frame1 url:ulrStr1 index:0];
        [self addSubview:img1];
        
        CGRect frame2 = CGRectMake(leftImgWidth + 4, 0, rightImgWidth, rightImgWidth);
        NSString *imgArrStr1 = _model.imgArr[1];
        NSArray *arr1 = [imgArrStr1 componentsSeparatedByString:@","];
        NSString *ulrStr2 ;
        for (NSString *str in arr1) {
            if (str.length > 6) {
                ulrStr2 =str;
            }
        }
        UIImageView *img2 = [self imageWith:frame2 url:ulrStr2 index:1];
        [self addSubview:img2];
        
        CGRect frame3 = CGRectMake(leftImgWidth + 4, rightImgWidth + 4, rightImgWidth, rightImgWidth);
        NSString *imgArrStr2 = _model.imgArr[2];
        NSArray *arr2 = [imgArrStr2 componentsSeparatedByString:@","];
        NSString *ulrStr3 ;
        for (NSString *str in arr2) {
            if (str.length > 6) {
                ulrStr3 =str;
            }
        }
        UIImageView *img3 = [self imageWith:frame3 url:ulrStr3 index:2];
        [self addSubview:img3];
        if(_model.imgArr.count > 3){
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, rightImgWidth, rightImgWidth)];
            btn.backgroundColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:0.468f];
            [btn setTitle:[NSString stringWithFormat:@"+%ld", _model.imgArr.count - 3] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:20.0];
            [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
            [img3 addSubview:btn];
        }
    }
}


- (UIImageView *)imageWith:(CGRect )frame url:(NSString *)url index:(NSInteger)index {
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:frame];
    [imgView sd_setImageWithURL:[NSURL URLWithString:url]];
    imgView.contentMode = UIViewContentModeScaleAspectFill;
    imgView.layer.masksToBounds = YES;
    imgView.userInteractionEnabled = YES;
    imgView.tag = 10000 + index;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImage:)];
    [imgView addGestureRecognizer:singleTap];
    
    return imgView;
}
- (void)clickBtn:(id)sender {
    [self.delegate clickedImageBtn:sender withModel:_model];
}
- (void)clickImage:(UIGestureRecognizer *)gestureRecognizer {
    NSInteger index = ((UIImageView *)gestureRecognizer.view).tag - 10000;
    [self openPhotoBrowser:index model:_model];
}
- (void)openPhotoBrowser:(NSInteger)index model:(ZhuBoModel *)model {
    
    [self.delegate openPhotoBrowser:index ZhuBoModel:model];
}

#pragma mark - photobrowser代理方法
- (UIImage *)photoBrowser:(HZPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    NSString *imgArrStr0 = _model.imgArr[index];
    NSArray *arr0 = [imgArrStr0 componentsSeparatedByString:@","];
    
    NSString *ulrStr ;
    for (NSString *str in arr0) {
        if (str.length > 6) {
            ulrStr =str;
        }
    }
    UIImageView *img = [self imageWith:self.frame url:ulrStr index:0];
    return img.image;//[self.subviews[index] currentImage];
}

- (ZhuBoModel *)photoBrowser:(HZPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    //    NSString *urlStr = [[self.photoItemArray[index] thumbnail_pic] stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"];
    return self.model;//[NSURL URLWithString:urlStr];
}

@end
