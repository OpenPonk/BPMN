Class {
	#name : #OPBPMNEdgeShape,
	#superclass : #OPEdge,
	#category : #'OpenPonk-BPMN-DiagramElements'
}

{ #category : #'as yet unclassified' }
OPBPMNEdgeShape >> createOwnedElementsWithoutController [

	super createOwnedElementsWithoutController.
	self ownedElements
		detect: [ :any | any isKindOf: OPBPMNEdgeLabel  ]
		ifFound: [ ^ self ].
	OPBPMNEdgeLabel in: self forModelElement: self modelElement
]

{ #category : #'as yet unclassified' }
OPBPMNEdgeShape >> headMarker [
	"line decoration shape used as head marker"

	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
OPBPMNEdgeShape >> renderBasicShape [

	^ self subclassResponsibility 
]
