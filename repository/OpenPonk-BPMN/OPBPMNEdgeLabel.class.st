Class {
	#name : #OPBPMNEdgeLabel,
	#superclass : #OPEdgeLabel,
	#category : #'OpenPonk-BPMN-DiagramElements'
}

{ #category : #'as yet unclassified' }
OPBPMNEdgeLabel >> defaultBalance [

	^ 0.4
]

{ #category : #'as yet unclassified' }
OPBPMNEdgeLabel >> defaultMinDistance [

	^ 5
]

{ #category : #'as yet unclassified' }
OPBPMNEdgeLabel >> text [

	^ self owningElement modelElement name
]
