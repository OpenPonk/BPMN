Class {
	#name : #OPBPMNSubProcessTest,
	#superclass : #OPBPMNNodeControllerTest,
	#category : #'OpenPonk-BPMN-Tests'
}

{ #category : #accessing }
OPBPMNSubProcessTest >> controllerClass [
	^ OPBPMNSubProcessController 
]

{ #category : #accessing }
OPBPMNSubProcessTest >> diagramElementClass [
	^ OPBPMNSubProcessShape 
]

{ #category : #accessing }
OPBPMNSubProcessTest >> modelClass [
	^ OPBPMNSubProcessModel 
]

{ #category : #accessing }
OPBPMNSubProcessTest >> targetControllerClass [
	^ OPBPMNPoolController  
]

{ #category : #accessing }
OPBPMNSubProcessTest >> targetModelClass [
	^ OPBPMNPoolModel 
]
