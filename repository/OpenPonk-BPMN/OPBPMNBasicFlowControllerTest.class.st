Class {
	#name : 'OPBPMNBasicFlowControllerTest',
	#superclass : 'OPBPMNFlowControllerTest',
	#category : 'OpenPonk-BPMN-Tests',
	#package : 'OpenPonk-BPMN',
	#tag : 'Tests'
}

{ #category : 'accessing' }
OPBPMNBasicFlowControllerTest >> controllerClass [
	^ OPBPMNFlowController
]

{ #category : 'accessing' }
OPBPMNBasicFlowControllerTest >> diagramElementClass [

	^ OPBPMNFlowShape 
]

{ #category : 'accessing' }
OPBPMNBasicFlowControllerTest >> modelClass [
	^ OPBPMNFlowModel 
]

{ #category : 'accessing' }
OPBPMNBasicFlowControllerTest >> sourceControllerClass [

	^ OPBPMNActivityController
]

{ #category : 'accessing' }
OPBPMNBasicFlowControllerTest >> sourceModelClass [
	^ OPBPMNActivityModel 
]
