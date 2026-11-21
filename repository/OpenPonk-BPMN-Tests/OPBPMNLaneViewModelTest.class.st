"
Verifies property descriptions, model synchronization, and containment rules for lane view models.
"
Class {
	#name : 'OPBPMNLaneViewModelTest',
	#superclass : 'OPAbstractViewModelTest',
	#category : 'OpenPonk-BPMN-Tests-ViewModels',
	#package : 'OpenPonk-BPMN-Tests',
	#tag : 'ViewModels'
}

{ #category : 'constants' }
OPBPMNLaneViewModelTest >> modelClass [

	^ OPBPMNLaneModel
]

{ #category : 'initialization' }
OPBPMNLaneViewModelTest >> newRootModel [

	^ OPBPMNModel named: 'TestProcess'
]

{ #category : 'initialization' }
OPBPMNLaneViewModelTest >> setUpParentModel [

	| pool |
	pool := OPBPMNPoolModel named: 'TestPool'.
	rootModel add: pool.
	^ pool
]

{ #category : 'tests' }
OPBPMNLaneViewModelTest >> testCaptureLanePositionOnUnattachedLaneAndDefaultInsertBefore [

	| testProject projectController testRegistry orphanLaneModel orphanLaneViewModel poolModel detachedLaneModel detachedLaneViewModel |
	testProject := OPProject new.
	projectController := OPProjectController forProject: testProject.
	testRegistry := projectController viewModelRegistry.

	orphanLaneModel := OPBPMNLaneModel new name: 'Orphan'.
	orphanLaneViewModel := testRegistry viewModelFor: orphanLaneModel.
	self deny: orphanLaneViewModel insertBefore description: 'Default insertBefore must be false'.
	orphanLaneViewModel captureLanePosition.
	self deny: orphanLaneViewModel insertBefore description: 'Capturing position on an unattached lane must keep insertBefore false'.

	poolModel := OPBPMNPoolModel new name: 'Pool'.
	testProject addModel: poolModel.
	detachedLaneModel := OPBPMNLaneModel new name: 'Detached'.
	detachedLaneModel addedTo: poolModel.
	detachedLaneViewModel := testRegistry viewModelFor: detachedLaneModel.
	detachedLaneViewModel basicRemoveModel.
	self assertEmpty: poolModel lanes
]

{ #category : 'tests' }
OPBPMNLaneViewModelTest >> testChildrenModelsContainsContainedNodes [
	| laneModel taskModel laneViewModel |
	laneModel := OPBPMNLaneModel new name: 'Operations'.
	taskModel := OPBPMNActivityModel new name: 'Check Stock'.
	laneModel add: taskModel.
	laneViewModel := OPBPMNLaneViewModel new model: laneModel.
	self assertCollection: laneViewModel childrenModels includesAll: { taskModel }
]

{ #category : 'tests' }
OPBPMNLaneViewModelTest >> testFormBindsName [

	| laneModel laneViewModel propertiesForm |
	laneModel := OPBPMNLaneModel new name: 'Operations'.
	laneViewModel := OPBPMNLaneViewModel new model: laneModel.
	propertiesForm := OPPropertiesForm new.
	propertiesForm viewModel: laneViewModel.
	self assert: (propertiesForm bindings collect: #selector as: Array) equals: #( #name ).
	self assert: (propertiesForm bindings collect: #class as: Array) equals: { OPFormTextBinding }.
	self
		assert: (propertiesForm bindings collect: [ :eachBinding | eachBinding presenter class ] as: Array)
		equals: { SpTextInputFieldPresenter }
]

{ #category : 'tests' }
OPBPMNLaneViewModelTest >> testIcon [

	| laneViewModel expectedIcon |
	laneViewModel := OPBPMNLaneViewModel new.
	expectedIcon := OPBPMNIcon current lane.
	self assert: laneViewModel icon class identicalTo: Form.
	self assert: laneViewModel icon extent equals: expectedIcon extent.
	self assert: laneViewModel icon bits equals: expectedIcon bits
]

{ #category : 'tests' }
OPBPMNLaneViewModelTest >> testParentViewModelResolvesToPoolViewModel [

	| testProject testRegistry poolModel laneModel poolViewModel laneViewModel |
	testProject := OPProject new.
	testRegistry := OPViewModelRegistry forProject: testProject.
	poolModel := OPBPMNPoolModel new name: 'Process Pool'.
	laneModel := OPBPMNLaneModel new name: 'Sales'.
	poolModel addLane: laneModel.
	poolViewModel := testRegistry viewModelFor: poolModel.
	laneViewModel := testRegistry viewModelFor: laneModel.
	self assert: laneViewModel parentViewModel equals: poolViewModel
]

{ #category : 'tests' }
OPBPMNLaneViewModelTest >> testRemoveLastLaneViaViewModelPreservesContainedElementsAndUpdatesParentViewModel [

	| testProject projectController testRegistry undoManager poolModel laneModel taskModel taskViewModel laneViewModel removeCommand |
	testProject := OPProject new.
	projectController := OPProjectController forProject: testProject.
	testRegistry := projectController viewModelRegistry.
	undoManager := projectController undoManager.
	poolModel := OPBPMNPoolModel new name: 'Order Fulfillment'.
	taskModel := OPBPMNActivityModel new name: 'Process Order'.
	poolModel add: taskModel.
	testProject addModel: poolModel.

	taskViewModel := testRegistry viewModelFor: taskModel.
	self assert: taskViewModel parentViewModel equals: (testRegistry viewModelFor: poolModel).

	laneModel := OPBPMNLaneModel new name: 'Sales'.
	poolModel addLane: laneModel.
	laneViewModel := testRegistry viewModelFor: laneModel.

	self assert: taskModel owner equals: laneModel.
	self assert: taskViewModel parentViewModel equals: laneViewModel.

	removeCommand := OPRemoveModelElementCommand model: laneModel projectController: projectController.
	undoManager inTransaction: [ undoManager execute: removeCommand ].

	self assertEmpty: poolModel lanes.
	self deny: poolModel hasLanes description: 'Pool must not have lanes after removing the last lane'.
	self assertCollection: poolModel elements includesAll: { taskModel }.
	self assert: taskModel owner equals: poolModel.
	self assert: taskViewModel parentViewModel equals: (testRegistry viewModelFor: poolModel)
]

{ #category : 'tests' }
OPBPMNLaneViewModelTest >> testUndoRemovingLastAndFirstLaneRestoresExactOrder [

	| testProject projectController undoManager poolModel firstLane secondLane removeLastCommand removeFirstCommand |
	testProject := OPProject new.
	projectController := OPProjectController forProject: testProject.
	undoManager := projectController undoManager.
	poolModel := OPBPMNPoolModel new name: 'Order Fulfillment'.
	firstLane := OPBPMNLaneModel new name: 'Sales'.
	secondLane := OPBPMNLaneModel new name: 'Warehouse'.
	poolModel
		addLane: firstLane;
		addLane: secondLane.
	testProject addModel: poolModel.

	removeLastCommand := OPRemoveModelElementCommand model: secondLane projectController: projectController.
	undoManager inTransaction: [ undoManager execute: removeLastCommand ].
	self assert: (poolModel lanes collect: #name as: Array) equals: #( 'Sales' ).

	undoManager undo.
	self assert: (poolModel lanes collect: #name as: Array) equals: #( 'Sales' 'Warehouse' ).

	removeFirstCommand := OPRemoveModelElementCommand model: firstLane projectController: projectController.
	undoManager inTransaction: [ undoManager execute: removeFirstCommand ].
	self assert: (poolModel lanes collect: #name as: Array) equals: #( 'Warehouse' ).

	undoManager undo.
	self assert: (poolModel lanes collect: #name as: Array) equals: #( 'Sales' 'Warehouse' )
]

{ #category : 'constants' }
OPBPMNLaneViewModelTest >> viewModelClass [

	^ OPBPMNLaneViewModel
]
