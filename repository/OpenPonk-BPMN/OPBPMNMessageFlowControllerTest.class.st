Class {
	#name : 'OPBPMNMessageFlowControllerTest',
	#superclass : 'OPBPMNEdgeControllerTest',
	#category : 'OpenPonk-BPMN-Tests',
	#package : 'OpenPonk-BPMN',
	#tag : 'Tests'
}

{ #category : 'accessing' }
OPBPMNMessageFlowControllerTest >> controllerClass [
	^ OPBPMNMessageFlowController
]

{ #category : 'accessing' }
OPBPMNMessageFlowControllerTest >> diagramElementClass [

	^ OPBPMNMessageShape 
]

{ #category : 'accessing' }
OPBPMNMessageFlowControllerTest >> modelClass [
	^ OPBPMNMessageFlowModel 
]

{ #category : 'accessing' }
OPBPMNMessageFlowControllerTest >> sourceControllerClass [
	^ OPBPMNPoolController  
]

{ #category : 'accessing' }
OPBPMNMessageFlowControllerTest >> sourceModelClass [
	^ OPBPMNPoolModel 
]
