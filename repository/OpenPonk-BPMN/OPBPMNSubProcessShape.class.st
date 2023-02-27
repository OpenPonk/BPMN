Class {
	#name : #OPBPMNSubProcessShape,
	#superclass : #OPBPMNNodeShape,
	#category : #'OpenPonk-BPMN-DiagramElements'
}

{ #category : #connecting }
OPBPMNSubProcessShape >> createRoassalShape [

	^ RSBox new
		  extent: 150 @ 100;
		  border: (RSBorder new
				   color: Color black;
				   width: 1);
		  cornerRadius: 10;
		  yourself
]

{ #category : #connecting }
OPBPMNSubProcessShape >> renderShapeDetails [

	| label selectable |
	label := RSLabeled new.
	label location top offset: 0 @ 17.
	label shapeBuilder labelShape color: Color black.
	roassalShape addInteraction: label.

	roassalShape @ OPRSSelectionDraggable.
	roassalShape @ RSTransformable.
	selectable := OPRSSelectable new.
	self setupHighlight: selectable.
	roassalShape @ selectable
]

{ #category : #connecting }
OPBPMNSubProcessShape >> typeIconForModel [

	
]

{ #category : #connecting }
OPBPMNSubProcessShape >> updateIcon [

	
]

{ #category : #connecting }
OPBPMNSubProcessShape >> updateRenderFromModel [

	(roassalShape propertyAt: #RSLabeled) text: self modelElement name.
	super updateRenderFromModel.

	roassalShape signalUpdate
]

{ #category : #connecting }
OPBPMNSubProcessShape >> updateRenderFromSelf [

	self isRendered ifFalse: [ ^ self ].
	roassalShape color: self color.

	super updateRenderFromSelf
]
