Class {
	#name : #OPBPMNBasicFlowControllerTest,
	#superclass : #OPBPMNFlowControllerTest,
	#category : #'OpenPonk-BPMN-Tests'
}

{ #category : #accessing }
OPBPMNBasicFlowControllerTest >> controllerClass [
	^ OPBPMNFlowController
]

{ #category : #accessing }
OPBPMNBasicFlowControllerTest >> diagramElementClass [

	^ OPBPMNFlowShape 
]

{ #category : #accessing }
OPBPMNBasicFlowControllerTest >> modelClass [
	^ OPBPMNFlowModel 
]

{ #category : #accessing }
OPBPMNBasicFlowControllerTest >> targetControllerClass [
	^ OPBPMNActivityController  
]

{ #category : #accessing }
OPBPMNBasicFlowControllerTest >> targetModelClass [
	^ OPBPMNActivityModel 
]
