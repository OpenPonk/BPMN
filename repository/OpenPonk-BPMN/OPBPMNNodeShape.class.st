Class {
	#name : #OPBPMNNodeShape,
	#superclass : #OPShape,
	#category : #'OpenPonk-BPMN-DiagramElements'
}

{ #category : #hooks }
OPBPMNNodeShape >> color [

	^ self stylePropertyNamed: #fillColor ifAbsent: [ Color transparent ]
]

{ #category : #hooks }
OPBPMNNodeShape >> color: aColor [

	^ self stylePropertyNamed: #fillColor put: aColor
]

{ #category : #hooks }
OPBPMNNodeShape >> renderBasicShape [

	roassalShape := self createRoassalShape model: self
]

{ #category : #hooks }
OPBPMNNodeShape >> renderShapeDetails [

	| label selectable |
	label := RSLabeled new.
	label location below.
	label shapeBuilder labelShape color: Color black.
	roassalShape addInteraction: label.

	roassalShape @ OPRSSelectionDraggable.
	selectable := OPRSSelectable new.
	self setupHighlight: selectable.
	roassalShape @ selectable
]

{ #category : #hooks }
OPBPMNNodeShape >> setupHighlight: aHighlightable [

	aHighlightable highlightBorderColor: Color blue
]
