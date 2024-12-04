Class {
	#name : 'OPBPMNBoundaryEventShape',
	#superclass : 'OPBPMNNodeShape',
	#instVars : [
		'borderIn',
		'borderOut',
		'innerCircle'
	],
	#category : 'OpenPonk-BPMN-DiagramElements',
	#package : 'OpenPonk-BPMN',
	#tag : 'DiagramElements'
}

{ #category : 'removing' }
OPBPMNBoundaryEventShape >> attachedShapes [

	^ super attachedShapes , { innerCircle }
]

{ #category : 'connecting' }
OPBPMNBoundaryEventShape >> createBorder [

	self modelElement
		ifNil: [ 
			borderIn := RSBorder new
				            dashArray: #( 1 0 );
				            color: Color black.
			borderOut := RSBorder new
				             dashArray: #( 1 0 );
				             color: Color black ]
		ifNotNil: [ 
			self modelElement isNonInterrupting
				ifTrue: [ 
					borderIn dashArray: #( 9 7 ).
					borderOut dashArray: #( 11 10 ) ]
				ifFalse: [ 
					borderIn dashArray: #( 1 0 ).
					borderOut dashArray: #( 1 0 ) ] ]
]

{ #category : 'connecting' }
OPBPMNBoundaryEventShape >> createRoassalShape [

	^ RSCircle new
		  size: 39;
		  borderColor: Color black;
		  border: borderOut;
		  yourself
]

{ #category : 'connecting' }
OPBPMNBoundaryEventShape >> initialize [
	super initialize.
	self createBorder.
]

{ #category : 'removing' }
OPBPMNBoundaryEventShape >> removeRender [

	super removeRender.
	innerCircle := nil
]

{ #category : 'connecting' }
OPBPMNBoundaryEventShape >> renderShapeDetails [

	| label |
	label := RSLabeled new.
	label location below offset: 0 @ 2.
	label shapeBuilder labelShape color: Color black.
	roassalShape addInteraction: label.
	self color: (Color fromHexString: 'fdd2d2').
	icon := RSBitmap new
		        form: self typeIconForModel;
		        yourself.
	self canvas add: icon.
	RSLocation new stick: icon on: self roassalShape.

	innerCircle := RSCircle new
		               size: 31;
		               borderColor: Color black;
		               color: Color transparent;
		               border: borderIn;
		               yourself.
	self canvas add: innerCircle.
	RSLocation new stick: innerCircle on: self roassalShape.
	"TODO for what are good bounds?????"
	"JanBliznicenko: To persist position and size for persistence"
	"self bounds: nil"
	"roassalShape @ OPRSSelectionDraggable."
]

{ #category : 'connecting' }
OPBPMNBoundaryEventShape >> testupdateRenderFromSelf [

	self isRendered ifFalse: [ ^ self ].
	roassalShape color: self color.
	self modelElement subscribeDiagram ifNotNil: [ 
		roassalShape translateTo:
			self modelElement subscribeDiagram position ].

	super updateRenderFromSelf
]

{ #category : 'connecting' }
OPBPMNBoundaryEventShape >> updateRenderFromModel [

	(roassalShape propertyAt: #RSLabeled) text: self modelElement name.
	self updateIcon.
	self createBorder.
	super updateRenderFromModel.

	roassalShape signalUpdate
]
