Class {
	#name : #OPBPMNMessageFlowControllerTest,
	#superclass : #OPBPMNFlowControllerTest,
	#category : #'OpenPonk-BPMN-Tests'
}

{ #category : #accessing }
OPBPMNMessageFlowControllerTest >> controllerClass [
	^ OPBPMNMessageFlowController
]

{ #category : #accessing }
OPBPMNMessageFlowControllerTest >> diagramElementClass [

	^ OPBPMNMessageShape 
]

{ #category : #accessing }
OPBPMNMessageFlowControllerTest >> modelClass [
	^ OPBPMNMessageFlowModel 
]

{ #category : #accessing }
OPBPMNMessageFlowControllerTest >> targetControllerClass [
	^ OPBPMNPoolController  
]

{ #category : #accessing }
OPBPMNMessageFlowControllerTest >> targetModelClass [
	^ OPBPMNPoolModel 
]
