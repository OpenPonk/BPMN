Class {
	#name : 'OPBPMNFlowControllerTest',
	#superclass : 'OPBPMNEdgeControllerTest',
	#category : 'OpenPonk-BPMN-Tests',
	#package : 'OpenPonk-BPMN',
	#tag : 'Tests'
}

{ #category : 'accessing' }
OPBPMNFlowControllerTest >> controllerClass [
	^ OPBPMNFlowController
]

{ #category : 'accessing' }
OPBPMNFlowControllerTest >> diagramElementClass [

	^ OPBPMNFlowShape 
]

{ #category : 'accessing' }
OPBPMNFlowControllerTest >> modelClass [
	^ OPBPMNFlowModel 
]

{ #category : 'accessing' }
OPBPMNFlowControllerTest >> sourceControllerClass [

	^ OPBPMNActivityController
]

{ #category : 'accessing' }
OPBPMNFlowControllerTest >> sourceModelClass [
	^ OPBPMNActivityModel 
]
