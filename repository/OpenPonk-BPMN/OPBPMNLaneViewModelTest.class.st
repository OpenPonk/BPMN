Class {
	#name : 'OPBPMNLaneViewModelTest',
	#superclass : 'TestCase',
	#category : 'OpenPonk-BPMN-Tests',
	#package : 'OpenPonk-BPMN',
	#tag : 'Tests'
}

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
	self assert: (propertiesForm bindings anySatisfy: [ :eachBinding | eachBinding selector = #name ])
]

{ #category : 'tests' }
OPBPMNLaneViewModelTest >> testIcon [
	| laneViewModel expectedIcon |
	laneViewModel := OPBPMNLaneViewModel new.
	expectedIcon := OPBPMNIcon current lane.
	self assert: laneViewModel icon isForm.
	self assert: laneViewModel icon extent equals: expectedIcon extent.
	self assert: laneViewModel icon bits equals: expectedIcon bits
]

{ #category : 'tests' }
OPBPMNLaneViewModelTest >> testModelClass [
	self assert: OPBPMNLaneViewModel modelClass equals: OPBPMNLaneModel
]

{ #category : 'tests' }
OPBPMNLaneViewModelTest >> testParentViewModelResolvesToPoolViewModel [
	| project registry poolModel laneModel poolViewModel laneViewModel |
	project := OPProject new.
	registry := OPViewModelRegistry forProject: project.
	poolModel := OPBPMNPoolModel new name: 'Process Pool'.
	laneModel := OPBPMNLaneModel new name: 'Sales'.
	poolModel addLane: laneModel.
	poolViewModel := registry viewModelFor: poolModel.
	laneViewModel := registry viewModelFor: laneModel.
	self assert: laneViewModel parentViewModel equals: poolViewModel
]

{ #category : 'tests' }
OPBPMNLaneViewModelTest >> testRegisteredInViewModelRegistry [
	OPViewModelRegistry resetCache.
	self assert: (OPViewModelRegistry viewModelClassFor: OPBPMNLaneModel) equals: OPBPMNLaneViewModel
]
