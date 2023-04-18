Class {
	#name : #OPBPMNIntermediateEventControllerTest,
	#superclass : #OPBPMNNodeControllerTest,
	#category : #'OpenPonk-BPMN-Tests'
}

{ #category : #accessing }
OPBPMNIntermediateEventControllerTest >> controllerClass [
	^ OPBPMNIntermediateEventController 
]

{ #category : #accessing }
OPBPMNIntermediateEventControllerTest >> diagramElementClass [
	^ OPBPMNIntermediateEventShape
]

{ #category : #accessing }
OPBPMNIntermediateEventControllerTest >> modelClass [
	^ OPBPMNIntermediateEventModel 
]

{ #category : #accessing }
OPBPMNIntermediateEventControllerTest >> targetControllerClass [
	^ OPBPMNPoolController  
]

{ #category : #accessing }
OPBPMNIntermediateEventControllerTest >> targetModelClass [
	^ OPBPMNPoolModel 
]
