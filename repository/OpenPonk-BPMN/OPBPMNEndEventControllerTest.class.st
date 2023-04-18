Class {
	#name : #OPBPMNEndEventControllerTest,
	#superclass : #OPBPMNNodeControllerTest,
	#category : #'OpenPonk-BPMN-Tests'
}

{ #category : #accessing }
OPBPMNEndEventControllerTest >> controllerClass [
	^ OPBPMNEndEventController 
]

{ #category : #accessing }
OPBPMNEndEventControllerTest >> diagramElementClass [

	^ OPBPMNEndEventShape 
]

{ #category : #accessing }
OPBPMNEndEventControllerTest >> modelClass [
	^ OPBPMNEndEventModel 
]

{ #category : #accessing }
OPBPMNEndEventControllerTest >> targetControllerClass [
	^ OPBPMNPoolController  
]

{ #category : #accessing }
OPBPMNEndEventControllerTest >> targetModelClass [
	^ OPBPMNPoolModel
]
