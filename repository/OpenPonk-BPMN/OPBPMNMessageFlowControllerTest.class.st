Class {
	#name : 'OPBPMNMessageFlowControllerTest',
	#superclass : 'OPBPMNFlowControllerTest',
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
