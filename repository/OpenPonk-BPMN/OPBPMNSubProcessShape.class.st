Class {
	#name : 'OPBPMNSubProcessShape',
	#superclass : 'OPBPMNNodeShape',
	#category : 'OpenPonk-BPMN-DiagramElements',
	#package : 'OpenPonk-BPMN',
	#tag : 'DiagramElements'
}

{ #category : 'connecting' }
OPBPMNSubProcessShape >> createRoassalShape [

	^ RSBox new
		  extent: 150 @ 100;
		  border: (RSBorder new
				   color: Color black;
				   width: 1);
		  cornerRadius: 10;
		  yourself
]

{ #category : 'rendering' }
OPBPMNSubProcessShape >> renderShapeDetails [

	| label |
	label := RSLabeled new.
	label location top offset: 0 @ 17.
	label shapeBuilder labelShape color: Color black.
	roassalShape addInteraction: label.

	roassalShape @ RSTransformable.
	
	"selectable := OPRSSelectable new.
	selectable highlightBorderColor: Color blue.
	roassalShape @ selectable.
	self roassalShape
@ OPRSSelectionDraggableBorder thatAlsoDragsContainedShapes;
		@ OPRSResizable;
		@ OPRSResizable" 
]

{ #category : 'connecting' }
OPBPMNSubProcessShape >> typeIconForModel [

	
]

{ #category : 'update' }
OPBPMNSubProcessShape >> updateIcon [

	
]

{ #category : 'rendering' }
OPBPMNSubProcessShape >> updateRenderFromModel [

	(roassalShape propertyAt: #RSLabeled) text: self modelElement name.
	super updateRenderFromModel.

	roassalShape signalUpdate
]

{ #category : 'roassal' }
OPBPMNSubProcessShape >> updateRenderFromSelf [

	self isRendered ifFalse: [ ^ self ].
	roassalShape color: self color.

	super updateRenderFromSelf
]
