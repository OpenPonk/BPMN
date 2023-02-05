Class {
	#name : #OPBPMNActivityShape,
	#superclass : #OPShape,
	#category : #'OpenPonk-BPMN-DiagramElements'
}

{ #category : #rendering }
OPBPMNActivityShape >> color [

	^ self stylePropertyNamed: #fillColor ifAbsent: [ Color transparent ]
]

{ #category : #rendering }
OPBPMNActivityShape >> color: aColor [

	^ self stylePropertyNamed: #fillColor put: aColor
]

{ #category : #rendering }
OPBPMNActivityShape >> createRoassalShape [
	^ RSBox new
		extent: 72@50;
		color: (Color fromHexString: 'f2f2f2');
		border: (RSBorder new
		color: (Color black);
		width: 2);
		cornerRadius: 10;
		yourself
	
]

{ #category : #rendering }
OPBPMNActivityShape >> renderBasicShape [

	roassalShape := self createRoassalShape model: self
]

{ #category : #rendering }
OPBPMNActivityShape >> renderShapeDetails [

	| label selectable |
	label := RSLabeled new.
	label location middle.
	label shapeBuilder labelShape color: Color black.
	roassalShape addInteraction: label.

	roassalShape @ OPRSSelectionDraggable.
	selectable := OPRSSelectable new.
	self setupHighlight: selectable.
	roassalShape @ selectable
]

{ #category : #rendering }
OPBPMNActivityShape >> setupHighlight: aHighlightable [

	aHighlightable highlightBorderColor: Color blue
]

{ #category : #rendering }
OPBPMNActivityShape >> updateRenderFromModel [

	(roassalShape propertyAt: #RSLabeled) text: self modelElement name.

	super updateRenderFromModel.

	roassalShape signalUpdate
]
