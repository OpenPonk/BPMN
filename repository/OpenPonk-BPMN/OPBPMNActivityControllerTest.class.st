Class {
	#name : #OPBPMNActivityControllerTest,
	#superclass : #OPBPMNNodeControllerTest,
	#category : #'OpenPonk-BPMN-Tests'
}

{ #category : #accessing }
OPBPMNActivityControllerTest >> controllerClass [
	^ OPBPMNActivityController 
]

{ #category : #accessing }
OPBPMNActivityControllerTest >> diagramElementClass [
	^ OPBPMNActivityShape
]

{ #category : #accessing }
OPBPMNActivityControllerTest >> modelClass [
	^ OPBPMNActivityModel 
]

{ #category : #accessing }
OPBPMNActivityControllerTest >> targetControllerClass [
	^ OPBPMNPoolController  
]

{ #category : #accessing }
OPBPMNActivityControllerTest >> targetModelClass [
	^ OPBPMNPoolModel 
]
