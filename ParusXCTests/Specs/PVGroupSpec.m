#import "PVGroup.h"
#import "PVLayout.h"
#import "PVVFL.h"
#import "NSArray+PVConvenientShorthands.h"

SpecBegin(PVGroup)

void(^compareConstraints)(NSLayoutConstraint*,NSLayoutConstraint*) =
^(NSLayoutConstraint* actual, NSLayoutConstraint* expected) {
    expect(actual.firstItem).to.equal(expected.firstItem);
    expect(actual.firstAttribute).to.equal(expected.firstAttribute);
    expect(actual.relation).to.equal(expected.relation);
    expect(actual.secondItem).to.equal(expected.secondItem);
    expect(actual.secondAttribute).to.equal(expected.secondAttribute);
    expect(actual.multiplier).to.equal(expected.multiplier);
    expect(actual.constant).to.equal(expected.constant);
    expect(actual.priority).to.equal(expected.priority);
};

describe(@"PVGroup syntax", ^{
    it(@"should accept literal array", ^{
        id r = PVGroup(@[]);
        expect(r).toNot.beNil();
    });
    
    it(@"should be convertable to array", ^{
        id r = PVGroup(@[]).asArray;
        expect(r).beKindOf([NSArray class]);
    });
    
    it(@"should be able to setup priority", ^{
        id r = PVGroup(@[]).withPriority(999);
        expect(r).toNot.beNil();
    });
    
    it(@"should allow setting group direction", ^{
        expect(PVGroup(@[]).fromLeftToRight).toNot.beNil();
        expect(PVGroup(@[]).fromRightToLeft).toNot.beNil();
        expect(PVGroup(@[]).fromLeadingToTrailing).toNot.beNil();
    });
    
    it(@"shoud be convertable to array after direction", ^{
        expect(PVGroup(@[]).fromLeadingToTrailing.asArray).beKindOf([NSArray class]);
        expect(PVGroup(@[]).fromLeftToRight.asArray).beKindOf([NSArray class]);
        expect(PVGroup(@[]).fromRightToLeft.asArray).beKindOf([NSArray class]);
    });
    
    it(@"should allow to set common views", ^{
        expect(PVGroup(@[]).withViews(@{})).toNot.beNil();
    });
    
    it(@"should allow conversion to array after views setting", ^{
        expect(PVGroup(@[]).withViews(@{}).asArray).beKindOf([NSArray class]);
    });
    
    it(@"should allow to set common views after direction", ^{
        expect(PVGroup(@[]).fromLeftToRight.withViews(@{})).toNot.beNil();
        expect(PVGroup(@[]).fromRightToLeft.withViews(@{})).toNot.beNil();
        expect(PVGroup(@[]).fromLeadingToTrailing.withViews(@{})).toNot.beNil();
    });
    
    it(@"should allow to [-> direction -> commonViews -> asArray]", ^{
        expect(PVGroup(@[]).fromLeftToRight.withViews(@{}).asArray).beKindOf([NSArray class]);
        expect(PVGroup(@[]).fromRightToLeft.withViews(@{}).asArray).beKindOf([NSArray class]);
        expect(PVGroup(@[]).fromLeadingToTrailing.withViews(@{}).asArray).beKindOf([NSArray class]);
    });
    
    it(@"should allow to set metrics", ^{
        expect(PVGroup(@[]).withMetrics(@{})).toNot.beNil();
    });
    
    it(@"should allow conversion to array after metrics", ^{
        expect(PVGroup(@[]).withMetrics(@{}).asArray).beKindOf([NSArray class]);
    });
    
    it(@"should allow set metrics after views", ^{
        expect(PVGroup(@[]).withViews(@{}).withMetrics(@{})).toNot.beNil();
    });
    
    it(@"should allow conversion to array after views and metrics setting", ^{
        expect(PVGroup(@[]).withViews(@{}).withMetrics(@{}).asArray).beKindOf([NSArray class]);
    });
    
    it(@"should allow to set common metrics after direction", ^{
        expect(PVGroup(@[]).fromLeftToRight.withMetrics(@{})).toNot.beNil();
        expect(PVGroup(@[]).fromRightToLeft.withMetrics(@{})).toNot.beNil();
        expect(PVGroup(@[]).fromLeadingToTrailing.withMetrics(@{})).toNot.beNil();
    });
    
    it(@"should allow to [-> direction -> metrics -> asArray]", ^{
        expect(PVGroup(@[]).fromLeftToRight.withMetrics(@{}).asArray).beKindOf([NSArray class]);
        expect(PVGroup(@[]).fromRightToLeft.withMetrics(@{}).asArray).beKindOf([NSArray class]);
        expect(PVGroup(@[]).fromLeadingToTrailing.withMetrics(@{}).asArray).beKindOf([NSArray class]);
    });
    
    it(@"should allow to set common views after direction", ^{
        expect(PVGroup(@[]).fromLeftToRight.withViews(@{}).withMetrics(@{})).toNot.beNil();
        expect(PVGroup(@[]).fromRightToLeft.withViews(@{}).withMetrics(@{})).toNot.beNil();
        expect(PVGroup(@[]).fromLeadingToTrailing.withViews(@{}).withMetrics(@{})).toNot.beNil();
    });
    
    it(@"should allow to [-> direction -> views -> metrics -> asArray]", ^{
        expect(PVGroup(@[]).fromLeftToRight.withViews(@{}).withMetrics(@{}).asArray)
        .beKindOf([NSArray class]);
        
        expect(PVGroup(@[]).fromRightToLeft.withViews(@{}).withMetrics(@{}).asArray)
        .beKindOf([NSArray class]);
        
        expect(PVGroup(@[]).fromLeadingToTrailing.withViews(@{}).withMetrics(@{}).asArray)
        .beKindOf([NSArray class]);
    });
});

describe(@"PVGroup data conversion", ^{
    
    __block PVView *view1;
    __block PVView *view2;
    __block NSLayoutConstraint* (^newConstraint)(void);
    
    beforeEach(^{
        view1 = [PVView new];
        view2 = [PVView new];
        newConstraint = ^{
            NSLayoutConstraint* c =
            [NSLayoutConstraint constraintWithItem:view1
                                         attribute:NSLayoutAttributeBaseline
                                         relatedBy:NSLayoutRelationEqual
                                            toItem:view2
                                         attribute:NSLayoutAttributeBaseline
                                        multiplier:1
                                          constant:0];
            return c;
        };
    });
    
    it(@"should return array from single array of constraints", ^{
        NSArray* constraints = @[newConstraint(),
                                 newConstraint(),
                                 newConstraint(),
                                 newConstraint()];
        NSArray* result = PVGroup(@[constraints]).asArray;
        
        expect(result).to.contain(constraints[0]);
        expect(result).to.contain(constraints[1]);
        expect(result).to.contain(constraints[2]);
        expect(result).to.contain(constraints[3]);
    });
    
    it(@"should return array from several indepenedend constraints", ^{
        NSLayoutConstraint* c1 = newConstraint();
        NSLayoutConstraint* c2 = newConstraint();
        NSLayoutConstraint* c3 = newConstraint();
        NSLayoutConstraint* c4 = newConstraint();
        
        NSArray* result = PVGroup(@[c1, c2, c3, c4]).asArray;
        
        expect(result).to.contain(c1);
        expect(result).to.contain(c2);
        expect(result).to.contain(c3);
        expect(result).to.contain(c4);
    });
    
    it(@"should return empty array from empty input", ^{
        expect(PVGroup(@[]).asArray).to.haveCountOf(0);
    });
    
    it(@"should concate arrays and single constraints", ^{
        NSLayoutConstraint* c1 = newConstraint();
        NSArray* array = @[newConstraint(), newConstraint()];
        
        NSArray* result = PVGroup(@[c1, array]).asArray;
        
        expect(result).haveCountOf(3);
        expect(result).to.contain(c1);
        expect(result).to.contain(array[0]);
        expect(result).to.contain(array[1]);
    });
    
    context(@"pv single constraint", ^{
        id(^singleConstraint)() = ^{
            return PVLeftOf(view1).equalTo.rightOf(view2);
        };
        
        it(@"should correct convert cons", ^{
            NSArray* result = PVGroup(@[singleConstraint()]).asArray;
            expect(result).haveCountOf(1);
            
            NSLayoutConstraint* actualC = [result lastObject];
            expect(actualC.firstItem).to.equal(view1);
            expect(actualC.firstAttribute).to.equal(NSLayoutAttributeLeft);
            expect(actualC.relation).to.equal(NSLayoutRelationEqual);
            expect(actualC.secondItem).to.equal(view2);
            expect(actualC.secondAttribute).to.equal(NSLayoutAttributeRight);
        });
        
        it(@"should support mixing PVSingle and classic constraints", ^{
            NSArray* result = PVGroup(@[singleConstraint(), newConstraint()]).asArray;
            expect(result).haveCountOf(2);
        });
        
        it(@"should support mixing single and array of constraints", ^{
            NSArray* array = @[newConstraint(), newConstraint()];
            NSArray* result = PVGroup(@[singleConstraint(), array]).asArray;
            expect(result).haveCountOf(3);
        });
        
        it(@"should transfor priority to single constraint", ^{
            NSArray* result = PVGroup(@[singleConstraint()]).withPriority(500).asArray;
            NSLayoutConstraint* constraint = result.lastObject;
            
            expect(constraint.priority).to.equal(500);
        });
        
        it(@"should not overwrite priority", ^{
            NSArray* result =
            PVGroup(@[ PVLeftOf(view1).equalTo.rightOf(view2).withPriority(1000),
                       PVLeftOf(view1).equalTo.rightOf(view2).withPriority(1),
                       PVLeftOf(view1).equalTo.rightOf(view2)
                       ]).withPriority(500).asArray;
            
            NSLayoutConstraint* c1 = result[0];
            NSLayoutConstraint* c2 = result[1];
            NSLayoutConstraint* c3 = result[2];
            
            expect(c1.priority).to.equal(1000);
            expect(c2.priority).to.equal(1);
            expect(c3.priority).to.equal(500);
        });
        
        it(@"should not touch priority when not set", ^{
            NSArray* result =
            PVGroup(@[ PVLeftOf(view1).equalTo.rightOf(view2).withPriority(500),
                       PVLeftOf(view1).equalTo.rightOf(view2).withPriority(1),
                       PVLeftOf(view1).equalTo.rightOf(view2)
                       ]).asArray;
            
            NSLayoutConstraint* c1 = result[0];
            NSLayoutConstraint* c2 = result[1];
            NSLayoutConstraint* c3 = result[2];
            
            expect(c1.priority).to.equal(500);
            expect(c2.priority).to.equal(1);
            expect(c3.priority).to.equal(1000);
        });
    });
    
    context(@"pv vfl", ^{
        __block NSDictionary* views;
        
        beforeEach(^{
            views = NSDictionaryOfVariableBindings(view1, view2);
        });
        
        it (@"should create vfl constraints", ^{
            NSArray* result = PVGroup(@[
                                      PVVFL(@"[view1]-20-[view2]").withViews(views)
                                      ]).asArray;
            expect(result).to.haveCountOf(1);
        });
        
        it(@"should transfer views to VFL context", ^{
            NSArray * result = PVGroup(@[
                PVVFL(@"[view1]-20-[view2]")
            ]).withViews(views).asArray;
            expect(result).to.haveCountOf(1);
        });
        
        it(@"should transfer direction to VFL context", ^{
            NSArray* r =
            PVGroup(@[PVVFL(@"[view1]-20-[view2]")]).fromRightToLeft.withViews(views).asArray;
            
            expect(r).to.haveCountOf(1);
            
            NSLayoutConstraint* e =
            [[NSLayoutConstraint constraintsWithVisualFormat:@"[view1]-20-[view2]"
                                                    options:NSLayoutFormatDirectionRightToLeft
                                                    metrics:nil
                                                      views:views] lastObject];
            
            NSLayoutConstraint* c = [r lastObject];
            
            compareConstraints(c,e);
        });
        
        it(@"should transfer metrics to VFL context", ^{
            
            NSDictionary* metrics = @{@"size":@20};
            
            NSArray* r =
            PVGroup(@[PVVFL(@"[view1]-size-[view2]")]).withViews(views).withMetrics(metrics).asArray;
            
            expect(r).to.haveCountOf(1);
            
            NSLayoutConstraint* e =
            [[NSLayoutConstraint constraintsWithVisualFormat:@"[view1]-size-[view2]"
                                                     options:0
                                                     metrics:metrics
                                                       views:views] lastObject];
            
            NSLayoutConstraint* c = [r lastObject];
            
            compareConstraints(c, e);
        });
        
        it(@"should not replace existing direction", ^{
            NSArray* r =
            PVGroup(@[PVVFL(@"[view1]-20-[view2]").fromLeftToRight]).fromRightToLeft.withViews(views).asArray;
            
            expect(r).to.haveCountOf(1);
            
            NSLayoutConstraint* e =
            [[NSLayoutConstraint constraintsWithVisualFormat:@"[view1]-20-[view2]"
                                                     options:NSLayoutFormatDirectionLeftToRight
                                                     metrics:nil
                                                       views:views] lastObject];
            
            NSLayoutConstraint* c = [r lastObject];
            
            compareConstraints(c, e);
        });
        
        it(@"should not replace existing metrics", ^{
            NSDictionary* metrics1 = @{@"size":@20};
            NSDictionary* metrics2 = @{@"size":@40};
            
            NSArray* r =
            PVGroup(@[PVVFL(@"[view1]-size-[view2]").metrics(metrics1)]).withViews(views).withMetrics(metrics2).asArray;
            
            expect(r).to.haveCountOf(1);
            
            NSLayoutConstraint* e =
            [[NSLayoutConstraint constraintsWithVisualFormat:@"[view1]-size-[view2]"
                                                     options:0
                                                     metrics:metrics1
                                                       views:views] lastObject];
            
            NSLayoutConstraint* c = [r lastObject];
            compareConstraints(c,e);
        });
        
        it(@"should not replace existing views", ^{
            // For live-testing))) 
        });
    });
});

SpecEnd
