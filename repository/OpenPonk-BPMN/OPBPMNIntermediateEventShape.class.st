"
I render a BPMN Intermediate Event as a Roassal shape, drawing the standard double-concentric circles associated with intermediate process triggers.
"
Class {
	#name : 'OPBPMNIntermediateEventShape',
	#superclass : 'OPBPMNEventShape',
	#instVars : [
		'innerCircle'
	],
	#category : 'OpenPonk-BPMN-DiagramElements',
	#package : 'OpenPonk-BPMN',
	#tag : 'DiagramElements'
}

{ #category : 'accessing' }
OPBPMNIntermediateEventShape >> attachedShapes [

	^ super attachedShapes , { innerCircle }
]

{ #category : 'connecting' }
OPBPMNIntermediateEventShape >> createRoassalShape [
	^ RSCircle new
		size: 39;
		borderColor: Color black;
		yourself
]

{ #category : 'rendering' }
OPBPMNIntermediateEventShape >> createTypeIconShape [
	self modelElement ifNil: [ ^ OPBPMNRoassalIconFactory emptyIcon ].
	^ OPBPMNRoassalIconFactory intermediateEventIconForType: self modelElement type
]

{ #category : 'removing' }
OPBPMNIntermediateEventShape >> removeRender [

	super removeRender.
	innerCircle := nil
]

{ #category : 'rendering' }
OPBPMNIntermediateEventShape >> renderShapeDetails [
	| label |
	label := RSLabeled new.
	label location below.
	label shapeBuilder labelShape color: Color black.
	roassalShape addInteraction: label.

	icon := self createTypeIconShape.
	self canvas add: icon.
	self attachIconShape.

	innerCircle := RSCircle new
		size: 31;
		borderColor: Color black;
		color: Color transparent;
		yourself.
	self canvas add: innerCircle.
	RSLocation new stick: innerCircle on: self roassalShape
]
