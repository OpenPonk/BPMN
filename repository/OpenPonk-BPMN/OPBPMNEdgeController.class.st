Class {
	#name : #OPBPMNEdgeController,
	#superclass : #OPDirectionalRelationshipController,
	#category : #'OpenPonk-BPMN-Controllers'
}

{ #category : #accessing }
OPBPMNEdgeController >> addLabels [
	self constraintLabel: #name balance: 0.4 offset: 12
]

{ #category : #accessing }
OPBPMNEdgeController >> constraintLabel: labelName balance: aFloat offset: aNumber [
	| label |
	label := (RTLabel new
		height: 10;
		color: figure shape color;
		text: self model name;
		element)
		@ RTDraggable;
		yourself.
	label model: figure.
	figure trachelShape
		addCallback:
			(TRRemoveCallback new
				block: [ :removedShape | 
					figure labels removeKey: labelName.
					label remove ]).
	figure labels at: labelName put: label.
	label renderIn: figure view.
	OPRTEdgeAlongConstraint
		stick: label
		alongEdge: figure
		balance: aFloat
		offset: aNumber.
	OPRTElementsConstraint
		whenDragging: label
		drawLineToPoint: [ ((figure shape startingPointOf: figure)
				+ (figure shape endingPointOf: figure)) / 2 ]
]

{ #category : #hooks }
OPBPMNEdgeController >> createLineFrom: fromElement to: toElement [
	^ self subclassResponsibility 
]

{ #category : #construction }
OPBPMNEdgeController >> createModelIn: aParentModel [
	self model: self modelClass new.
	model source: self source model.
	model target: self target model.
	source model addFlow: model.
	target model addFlow: model.
	"(aParentModel owner isKindOf: OPBPMNPoolModel) 
	ifTrue: [ (aParentModel owner) owner add: model ]
	ifFalse: [ aParentModel owner add: model ]."
	^ model
]

{ #category : #private }
OPBPMNEdgeController >> headMarker [
	"line decoration shape class used as head"

	^ self subclassResponsibility
]

{ #category : #accessing }
OPBPMNEdgeController >> hideSelectionFeedback [
	self figure view
		ifNotNil: [ self figure announce: OPTRUnfocused.
			self figure view signalUpdate ]
]

{ #category : #private }
OPBPMNEdgeController >> isHideable [
	^ true
]

{ #category : #private }
OPBPMNEdgeController >> modelClass [
	^ self subclassResponsibility
]

{ #category : #accessing }
OPBPMNEdgeController >> refreshFigure [
	super refreshFigure.
	(figure labels at: #name) trachelShape text: self model name.
	^ self figure
]

{ #category : #private }
OPBPMNEdgeController >> removeModel [
	self diagramController model remove: self model.
	self model target removeFlow: self model.
	self model source removeFlow: self model
]

{ #category : #accessing }
OPBPMNEdgeController >> renderFigureIn: aView [
	self diagramController addingFigureFor: self.
	figure := self
		createLineFrom: self source figure
		to: self target figure.
	figure renderIn: aView.
	self addLabels.
	^ self diagramController addedFigureFor: self
]

{ #category : #accessing }
OPBPMNEdgeController >> showInDiagram: aDiagramController [
	source
		ifNil: [ self source: (aDiagramController showWithoutDependentInDiagramModel: model source) ].
	target
		ifNil: [ self target: (aDiagramController showWithoutDependentInDiagramModel: model target) ].
	^ super showInDiagram: aDiagramController
]

{ #category : #accessing }
OPBPMNEdgeController >> showSelectionFeedback [
	self figure announce: OPTRFocused.
	self figure view signalUpdate
]

{ #category : #accessing }
OPBPMNEdgeController >> showWithoutDependentInDiagram: aDiagramController [
	source
		ifNil:
			[ self source: (aDiagramController showWithoutDependentInDiagramModel: model source) ].
	target
		ifNil: [ self target: (aDiagramController showWithoutDependentInDiagramModel: model target) ].
	^ super showWithoutDependentInDiagram: aDiagramController
]
