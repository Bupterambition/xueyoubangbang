//
//  UULineChart.m
//  UUChartDemo
//
//  Created by shake on 14-7-24.
//  Copyright (c) 2014年 uyiuyao. All rights reserved.
//

#import "UULineChart.h"
#import "UUColor.h"
#import "UUChartLabel.h"


@implementation UULineChart {
    NSHashTable *_chartLabelsForX;
    UIScrollView *myScrollView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        myScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(UUYLabelwidth, 0, frame.size.width-UUYLabelwidth, frame.size.height)];
        myScrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:myScrollView];
        self.clipsToBounds = YES;
    }
    return self;
}

-(void)setYValues:(NSArray *)yValues
{
    _yValues = yValues;
    [self setYLabels:yValues];
}

-(void)setYLabels:(NSArray *)yLabels
{
    NSInteger max = 0;
    NSInteger min = 1000000000;

    for (NSArray * ary in yLabels) {
        for (NSString *valueString in ary) {
            NSInteger value = [valueString integerValue];
            if (value > max) {
                max = value;
            }
            if (value < min) {
                min = value;
            }
        }
    }
    if (max < 5) {
        max = 5;
    }
    if (self.showRange) {
        _yValueMin = min;
    }else{
        _yValueMin = 0;
    }
    _yValueMax = (int)max;
    
    if (_chooseRange.max!=_chooseRange.min) {
        _yValueMax = _chooseRange.max;
        _yValueMin = _chooseRange.min;
    }

    float level = (_yValueMax-_yValueMin) /4.0;
    CGFloat chartCavanHeight = self.frame.size.height - UULabelHeight*3;
    CGFloat levelHeight = chartCavanHeight /4.0;

    for (int i=0; i<5; i++) {
        UUChartLabel * label = [[UUChartLabel alloc] initWithFrame:CGRectMake(0.0,chartCavanHeight-i*levelHeight+5, UUYLabelwidth, UULabelHeight)];
		label.text = [NSString stringWithFormat:@"%d",(int)(level * i+_yValueMin)];
		[self addSubview:label];
    }
    if ([super respondsToSelector:@selector(setMarkRange:)]) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(UUYLabelwidth, (1-(_markRange.max-_yValueMin)/(_yValueMax-_yValueMin))*chartCavanHeight+UULabelHeight, self.frame.size.width-UUYLabelwidth, (_markRange.max-_markRange.min)/(_yValueMax-_yValueMin)*chartCavanHeight)];
        view.backgroundColor = [[UIColor clearColor] colorWithAlphaComponent:0.1];
//        [self addSubview:view];
    }

    //画横线
    for (int i=0; i<5; i++) {
        if ([_ShowHorizonLine[i] integerValue]>0) {
            
            CAShapeLayer *shapeLayer = [CAShapeLayer layer];
            UIBezierPath *path = [UIBezierPath bezierPath];
            [path moveToPoint:CGPointMake(UUYLabelwidth,UULabelHeight+i*levelHeight)];
            [path addLineToPoint:CGPointMake(self.frame.size.width,UULabelHeight+i*levelHeight)];
            [path closePath];
            shapeLayer.path = path.CGPath;
            shapeLayer.strokeColor = [[[UIColor blackColor] colorWithAlphaComponent:0.1] CGColor];
            shapeLayer.fillColor = [[UIColor whiteColor] CGColor];
            shapeLayer.lineWidth = 1;
            [self.layer addSublayer:shapeLayer];
        }
    }
}

-(void)setXLabels:(NSArray *)xLabels
{
    if( !_chartLabelsForX ){
        _chartLabelsForX = [NSHashTable weakObjectsHashTable];
    }
    //可以删除
    _xLabels = xLabels;
    NSInteger num;
    if (xLabels.count>=8) {
        num = 8;
    }else if (xLabels.count<=4){
        num = 4;
    }else{
        num = xLabels.count;
    }
    _xLabelWidth = myScrollView.frame.size.width/num;
    [myScrollView.subviews enumerateObjectsUsingBlock:^(UIView* obj, NSUInteger idx, BOOL *stop) {
        [obj removeFromSuperview];
    }];
    for (int i=0; i<xLabels.count; i++) {
        UUChartLabel * label = [[UUChartLabel alloc] initWithFrame:CGRectMake((i *  _xLabelWidth ), self.frame.size.height - UULabelHeight, _xLabelWidth, UULabelHeight)];
        label.text = xLabels[i];
        [myScrollView addSubview:label];
        
        [_chartLabelsForX addObject:label];
    }
    
    float max = (([xLabels count]-1)*_xLabelWidth + chartMargin)+_xLabelWidth;
    if (myScrollView.frame.size.width < max-10) {
        myScrollView.contentSize = CGSizeMake(max, self.frame.size.height);
    }//可以删除

    
//    _xLabels = xLabels;//还原
//    CGFloat num = 0;
//    if (xLabels.count>=20) {
//        num=20.0;
//    }else if (xLabels.count<=1){
//        num=1.0;
//    }else{
//        num = xLabels.count;
//    }
//    _xLabelWidth = (self.frame.size.width - UUYLabelwidth)/num;
//    
//    for (int i=0; i<xLabels.count; i++) {
//        NSString *labelText = xLabels[i];
//        UUChartLabel * label = [[UUChartLabel alloc] initWithFrame:CGRectMake(i * _xLabelWidth+UUYLabelwidth, self.frame.size.height - UULabelHeight, _xLabelWidth, UULabelHeight)];
//        label.text = labelText;
//        [self addSubview:label];
//        [_chartLabelsForX addObject:label];//可以删除
//    }
    
    //画竖线
    for (int i=0; i<xLabels.count+1; i++) {
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(UUYLabelwidth+i*_xLabelWidth,UULabelHeight)];
        [path addLineToPoint:CGPointMake(UUYLabelwidth+i*_xLabelWidth,self.frame.size.height-2*UULabelHeight)];
        [path closePath];
        shapeLayer.path = path.CGPath;
        shapeLayer.strokeColor = [[[UIColor blackColor] colorWithAlphaComponent:0.1] CGColor];
        shapeLayer.fillColor = [[UIColor whiteColor] CGColor];
        shapeLayer.lineWidth = 1;
        [self.layer addSublayer:shapeLayer];
    }
}

-(void)setColors:(NSArray *)colors
{
	_colors = colors;
}

- (void)setMarkRange:(CGRange)markRange
{
    _markRange = markRange;
}

- (void)setChooseRange:(CGRange)chooseRange
{
    _chooseRange = chooseRange;
}

- (void)setShowHorizonLine:(NSMutableArray *)ShowHorizonLine
{
    _ShowHorizonLine = ShowHorizonLine;
}


-(void)strokeChart
{
    for (int i=0; i<_yValues.count; i++) {
        NSArray *childAry = _yValues[i];
        if (childAry.count==0) {
            return;
        }
        //获取最大最小位置
        CGFloat max = [childAry[0] floatValue];
        CGFloat min = [childAry[0] floatValue];
        NSInteger max_i = 0;
        NSInteger min_i = 0;
        
        for (int j=0; j<childAry.count; j++){
            CGFloat num = [childAry[j] floatValue];
            if (max<=num){
                max = num;
                max_i = j;
            }
            if (min>=num){
                min = num;
                min_i = j;
            }
        }
        
        //划线
        [[myScrollView.layer sublayers] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if ([obj isKindOfClass:[CAShapeLayer class]]) {
                [obj removeFromSuperlayer];
            }
        }];
        CAShapeLayer *_chartLine = [CAShapeLayer layer];
        _chartLine.lineCap = kCALineCapRound;
        _chartLine.lineJoin = kCALineJoinBevel;
        _chartLine.fillColor   = [[UIColor whiteColor] CGColor];
        _chartLine.lineWidth   = 2.0;
        _chartLine.strokeEnd   = 0.0;
        [myScrollView.layer addSublayer:_chartLine];
        
        UIBezierPath *progressline = [UIBezierPath bezierPath];
        CGFloat firstValue = [[childAry objectAtIndex:0] floatValue];
        CGFloat xPosition = (UUYLabelwidth + _xLabelWidth/2.0);
        CGFloat chartCavanHeight = self.frame.size.height - UULabelHeight*3;
        
        float grade = ((float)firstValue-_yValueMin) / ((float)_yValueMax-_yValueMin);
       
        //第一个点
        BOOL isShowMaxAndMinPoint = YES;
        if (self.ShowMaxMinArray) {
            if ([self.ShowMaxMinArray[i] intValue]>0) {
                isShowMaxAndMinPoint = (max_i==0 || min_i==0)?NO:YES;
            }else{
                isShowMaxAndMinPoint = YES;
            }
        }
        [self addPoint:CGPointMake(xPosition - UUYLabelwidth, chartCavanHeight - grade * chartCavanHeight+UULabelHeight)
                 index:i
                isShow:isShowMaxAndMinPoint
                 value:firstValue];

        
        [progressline moveToPoint:CGPointMake(xPosition - UUYLabelwidth, chartCavanHeight - grade * chartCavanHeight+UULabelHeight)];
        [progressline setLineWidth:2.0];
        [progressline setLineCapStyle:kCGLineCapRound];
        [progressline setLineJoinStyle:kCGLineJoinRound];
        NSInteger index = 0;
        for (NSString * valueString in childAry) {
            
            float grade =([valueString floatValue]-_yValueMin) / ((float)_yValueMax-_yValueMin);
            if (index != 0) {
                
                CGPoint point = CGPointMake(xPosition+index*_xLabelWidth - UUYLabelwidth, chartCavanHeight - grade * chartCavanHeight+UULabelHeight);
                [progressline addLineToPoint:point];
                
                BOOL isShowMaxAndMinPoint = YES;
                if (self.ShowMaxMinArray) {
                    if ([self.ShowMaxMinArray[i] intValue]>0) {
                        isShowMaxAndMinPoint = (max_i==index || min_i==index)?NO:YES;
                    }else{
                        isShowMaxAndMinPoint = YES;
                    }
                }
                [progressline moveToPoint:point];
                [self addPoint:point
                         index:i
                        isShow:isShowMaxAndMinPoint
                         value:[valueString floatValue]];
                
//                [progressline stroke];
            }
            index += 1;
        }
        
        _chartLine.path = progressline.CGPath;
        if ([[_colors objectAtIndex:i] CGColor]) {
            _chartLine.strokeColor = [[_colors objectAtIndex:i] CGColor];
        }else{
            _chartLine.strokeColor = [UUGreen CGColor];
        }
        CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        pathAnimation.duration = childAry.count*0.4;
        pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
        pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
        pathAnimation.autoreverses = NO;
        [_chartLine addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
        
        _chartLine.strokeEnd = 1.0;
    }
}

- (void)addPoint:(CGPoint)point index:(NSInteger)index isShow:(BOOL)isHollow value:(CGFloat)value
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(5, 5, 8, 8)];
    view.center = point;
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = 4;
    view.layer.borderWidth = 2;
    view.layer.borderColor = [[_colors objectAtIndex:index] CGColor]?[[_colors objectAtIndex:index] CGColor]:UUGreen.CGColor;
    
    if (isHollow) {
        view.backgroundColor = [UIColor whiteColor];
    }else{
        view.backgroundColor = [_colors objectAtIndex:index]?[_colors objectAtIndex:index]:UUGreen;
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(point.x-UUTagLabelwidth/2.0, point.y-UULabelHeight*2, UUTagLabelwidth, UULabelHeight)];
        label.font = [UIFont systemFontOfSize:10];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = view.backgroundColor;
        label.text = [NSString stringWithFormat:@"%d",(int)value];
        [myScrollView addSubview:label];
    }
    
    [myScrollView addSubview:view];
}

- (NSArray *)chartLabelsForX
{
    return [_chartLabelsForX allObjects];
}

@end
