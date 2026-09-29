Class {
	#name : 'OPBPMNLaneModelTest',
	#superclass : 'TestCase',
	#category : 'OpenPonk-BPMN-Tests',
	#package : 'OpenPonk-BPMN',
	#tag : 'Tests'
}

{ #category : 'tests - adoption' }
OPBPMNLaneModelTest >> testAddingFirstLaneAdoptsExistingFlowNodesFromPool [
	| poolModel laneModel activityModel |
	poolModel := OPBPMNPoolModel new name: 'Order Fulfillment'.
	activityModel := OPBPMNActivityModel new name: 'Process Order'.
	poolModel add: activityModel.
	self assertCollection: poolModel elements includesAll: { activityModel }.
	self assert: activityModel owner equals: poolModel.
	
	laneModel := OPBPMNLaneModel new name: 'Sales'.
	poolModel addLane: laneModel.
	
	self assertCollection: laneModel flowNodes includesAll: { activityModel }.
	self assert: activityModel owner equals: laneModel.
	self assert: activityModel enclosingPool equals: poolModel.
	self denyCollection: poolModel elements includesAny: { activityModel }
]

{ #category : 'tests' }
OPBPMNLaneModelTest >> testLaneContainsFlowNodesAndEnclosingPoolPropagates [
	| poolModel laneModel activityModel |
	poolModel := OPBPMNPoolModel new.
	poolModel name: 'Order Fulfillment'.
	laneModel := OPBPMNLaneModel new.
	laneModel name: 'Sales'.
	poolModel addLane: laneModel.
	activityModel := OPBPMNActivityModel new.
	activityModel name: 'Check Stock'.
	laneModel add: activityModel.
	self assert: activityModel owner equals: laneModel.
	self assert: activityModel enclosingPool equals: poolModel.
	self assertCollection: laneModel elements includesAll: { activityModel }.
	self assertCollection: laneModel flowNodes includesAll: { activityModel }
]

{ #category : 'tests' }
OPBPMNLaneModelTest >> testLaneEnclosingPool [
	| poolModel laneModel |
	poolModel := OPBPMNPoolModel new.
	poolModel name: 'Order Fulfillment'.
	laneModel := OPBPMNLaneModel new.
	laneModel name: 'Sales'.
	poolModel addLane: laneModel.
	self assert: laneModel owner equals: poolModel.
	self assert: laneModel enclosingPool equals: poolModel.
	self assert: laneModel pool equals: poolModel
]

{ #category : 'tests' }
OPBPMNLaneModelTest >> testPoolLanesAndQueryMethods [
	| poolModel laneSales laneWarehouse taskCheckStock taskPackItems |
	poolModel := OPBPMNPoolModel new.
	poolModel name: 'Order Fulfillment'.
	laneSales := OPBPMNLaneModel new.
	laneSales name: 'Sales'.
	laneWarehouse := OPBPMNLaneModel new.
	laneWarehouse name: 'Warehouse'.
	poolModel addLane: laneSales.
	poolModel addLane: laneWarehouse.
	taskCheckStock := OPBPMNActivityModel new.
	taskCheckStock name: 'Check Stock'.
	taskPackItems := OPBPMNActivityModel new.
	taskPackItems name: 'Pack Items'.
	laneSales add: taskCheckStock.
	laneWarehouse add: taskPackItems.
	self assert: poolModel hasLanes.
	self assertCollection: poolModel lanes hasSameElements: { laneSales . laneWarehouse }.
	self assert: (poolModel laneFor: taskCheckStock) equals: laneSales.
	self assert: (poolModel laneFor: taskPackItems) equals: laneWarehouse.
	self assertCollection: poolModel flowNodesInLanes hasSameElements: { taskCheckStock . taskPackItems }.
	self assert: (poolModel laneNamed: 'Sales') equals: laneSales.
	self assert: (poolModel laneNamed: 'Warehouse') equals: laneWarehouse.
	self assert: (poolModel laneNamed: 'Finance') isNil
]

{ #category : 'tests' }
OPBPMNLaneModelTest >> testPoolLanesCollectionManipulation [
	| poolModel laneSales laneWarehouse |
	poolModel := OPBPMNPoolModel new name: 'Corporate Pool'.
	laneSales := OPBPMNLaneModel new name: 'Sales'.
	laneWarehouse := OPBPMNLaneModel new name: 'Warehouse'.
	
	poolModel addLane: laneSales.
	poolModel addLane: laneWarehouse.
	
	self assert: poolModel lanes size equals: 2.
	self assert: poolModel lanes first equals: laneSales.
	self assert: poolModel lanes second equals: laneWarehouse.
	
	poolModel removeLane: laneSales.
	self assert: poolModel lanes size equals: 1.
	self assert: poolModel lanes first equals: laneWarehouse
]

{ #category : 'tests' }
OPBPMNLaneModelTest >> testRemovingLaneCascadesContainedNodesAndFlows [
	| poolModel laneSales laneWarehouse taskCheckStock taskPackItems flowModel |
	poolModel := OPBPMNPoolModel new.
	poolModel name: 'Order Fulfillment'.
	laneSales := OPBPMNLaneModel new.
	laneSales name: 'Sales'.
	laneWarehouse := OPBPMNLaneModel new.
	laneWarehouse name: 'Warehouse'.
	poolModel addLane: laneSales.
	poolModel addLane: laneWarehouse.
	taskCheckStock := OPBPMNActivityModel new.
	taskCheckStock name: 'Check Stock'.
	taskPackItems := OPBPMNActivityModel new.
	taskPackItems name: 'Pack Items'.
	laneSales add: taskCheckStock.
	laneWarehouse add: taskPackItems.
	flowModel := (OPBPMNFlowModel from: taskCheckStock to: taskPackItems)
		name: '';
		type: 'Normal';
		yourself.
	taskCheckStock addFlow: flowModel.
	taskPackItems addFlow: flowModel.
	poolModel removeLane: laneSales.
	self deny: (poolModel lanes includes: laneSales).
	self assert: laneSales owner isNil.
	self assert: taskCheckStock owner isNil.
	self deny: (taskPackItems incoming includes: flowModel)
]

{ #category : 'tests - adoption' }
OPBPMNLaneModelTest >> testRemovingLastLaneRestoresFlowNodesToPool [
	| poolModel laneModel activityModel |
	poolModel := OPBPMNPoolModel new name: 'Order Fulfillment'.
	laneModel := OPBPMNLaneModel new name: 'Sales'.
	poolModel addLane: laneModel.
	activityModel := OPBPMNActivityModel new name: 'Process Order'.
	laneModel add: activityModel.
	
	poolModel removeLane: laneModel.
	
	self deny: poolModel hasLanes.
	self assertCollection: poolModel elements includesAll: { activityModel }.
	self assert: activityModel owner equals: poolModel.
	self assert: activityModel enclosingPool equals: poolModel
]
