//
//  RAFTableSection.m
//  ReactiveFormlets
//
//  Created by Jon Sterling on 6/12/12.
//  Copyright (c) 2012 Jon Sterling. All rights reserved.
//

#import "RAFTableSection.h"
#import "RAFTableRow.h"
#import "RAFTableForm.h"
#import "RAFFormlet.h"

@interface RAFTableSection () <RAFMutableTableSection>
@end

@implementation RAFTableSection
@synthesize headerTitle = _headerTitle;
@synthesize footerTitle = _footerTitle;
@synthesize headerView = _headerView;
@synthesize footerView = _footerView;
@synthesize rows = _rows;
@synthesize uniqueIdentifier = _uniqueIdentifier;

- (id)initWithUniqueIdentifier:(NSString *)identifier rows:(NSArray *)rows headerTitle:(NSString *)headerTitle footerTitle:(NSString *)footerTitle headerView:(UIView *)headerView footerView:(UIView *)footerView {
	if (self = [super init]) {
		self.uniqueIdentifier = identifier;
		self.rows = rows;
		self.headerTitle = headerTitle;
		self.footerTitle = footerTitle;
		self.headerView = headerView;
		self.footerView = footerView;
	}

	return self;
}

+ (instancetype)uniqueIdentifier:(NSString *)identifier rows:(NSArray *)rows {
	return [[self alloc] initWithUniqueIdentifier:identifier rows:rows headerTitle:nil footerTitle:nil headerView:nil footerView:nil];
}

+ (instancetype)uniqueIdentifier:(NSString *)identifier rows:(NSArray *)rows headerTitle:(NSString *)headerTitle footerTitle:(NSString *)footerTitle {
	return [[self alloc] initWithUniqueIdentifier:identifier rows:rows headerTitle:headerTitle footerTitle:footerTitle headerView:nil footerView:nil];
}

- (id)initWithOrderedDictionary:(RAFOrderedDictionary *)dictionary {
	if (self = [super initWithOrderedDictionary:dictionary]) {
		self.rows = self.allValues;
	}

	return self;
}

- (id)copyWithZone:(NSZone *)zone {
	RAFTableSection *copy = [super copyWithZone:zone];
	copy.headerTitle = [_headerTitle copy];
	copy.footerTitle = [_footerTitle copy];
	copy.rows = [_rows copy];
	return copy;
}

- (instancetype)modifySection:(RAFTableSectionModifyBlock)block {
	RAFTableSection *copy = [self mutableCopy];
	block(copy);
	return copy;
}

- (NSUInteger)hash {
	return self.uniqueIdentifier ? self.uniqueIdentifier.hash : super.hash;
}

- (BOOL)isEqual:(RAFTableSection *)section {
	if (![section isKindOfClass:[RAFTableSection class]]) return NO;

	if (self.uniqueIdentifier && section.uniqueIdentifier) {
		return [self.uniqueIdentifier isEqualToString:section.uniqueIdentifier];
	}

	return [super isEqual:section];
}

- (RACSignal *)moments {
	NSArray *components = @[ RACAbleWithStart(self.uniqueIdentifier),
							 RACAbleWithStart(self.rows),
							 RACAbleWithStart(self.headerTitle),
							 RACAbleWithStart(self.footerTitle),
							 RACAbleWithStart(self.headerView),
							 RACAbleWithStart(self.footerView) ];

	Class SectionClass = self.class;
	return [RACSignal combineLatest:components reduce:^(NSString *identifier, NSArray *rows, NSString *headerTitle, NSString *footertitle, UIView *headerView, UIView *footerView) {
		return [[SectionClass alloc] initWithUniqueIdentifier:identifier rows:rows headerTitle:headerTitle footerTitle:footertitle headerView:headerView footerView:footerView];
	}];
}

@end
