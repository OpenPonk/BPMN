"
Verifies cascading removal, node containment, and ownership transitions within BPMN lane models.
"
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

{ #category : 'tests - adoption' }
OPBPMNLaneModelTest >> testAddingFirstLaneAndRemovingLastLaneMigratesDataObjectsAndAnnotations [
	| poolModel laneModel taskModel dataObjectModel annotationModel |
	poolModel := OPBPMNPoolModel new name: 'Order Fulfillment'.
	taskModel := OPBPMNActivityModel new name: 'Process Order'.
	dataObjectModel := OPBPMNDataObjectModel new name: 'Order Data'.
	annotationModel := OPBPMNAnnotationModel new text: 'SLA 24h'.
	poolModel add: taskModel; add: dataObjectModel; add: annotationModel.

	laneModel := OPBPMNLaneModel new name: 'Sales'.
	poolModel addLane: laneModel.

	self assertCollection: laneModel elements includesAll: { taskModel . dataObjectModel . annotationModel }.
	self assert: dataObjectModel owner equals: laneModel.
	self assert: annotationModel owner equals: laneModel.
	self denyCollection: poolModel elements includesAny: { taskModel . dataObjectModel . annotationModel }.

	poolModel removeLane: laneModel.

	self assertCollection: poolModel elements includesAll: { taskModel . dataObjectModel . annotationModel }.
	self assert: dataObjectModel owner equals: poolModel.
	self assert: annotationModel owner equals: poolModel
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
	self denyCollection: poolModel lanes includesAny: { laneSales }.
	self assert: laneSales owner isNil.
	self assert: taskCheckStock owner isNil.
	self denyCollection: taskPackItems incoming includesAny: { flowModel }
]

{ #category : 'tests' }
OPBPMNLaneModelTest >> testRemovingLaneDisconnectsAttachedAssociationsFromPeerNodes [
	| poolModel laneModel annotationModel associationModel |
	poolModel := OPBPMNPoolModel new name: 'Pool'.
	laneModel := OPBPMNLaneModel new name: 'Sales'.
	annotationModel := OPBPMNAnnotationModel new text: 'Lane Note'.
	poolModel addLane: laneModel.
	poolModel add: annotationModel.
	associationModel := OPBPMNAssociationModel new
		source: annotationModel;
		target: laneModel;
		yourself.
	annotationModel addAssociation: associationModel.
	laneModel addAssociation: associationModel.

	poolModel removeLane: laneModel.

	self denyCollection: annotationModel associations includesAny: { associationModel }
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
