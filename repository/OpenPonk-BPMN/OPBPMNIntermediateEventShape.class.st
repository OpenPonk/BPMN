Class {
	#name : 'OPBPMNIntermediateEventShape',
	#superclass : 'OPBPMNEventShape',
	#instVars : [
		'innerCircle'
	],
	#category : 'OpenPonk-BPMN-Shapes',
	#package : 'OpenPonk-BPMN',
	#tag : 'Shapes'
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

{ #category : 'removing' }
OPBPMNIntermediateEventShape >> removeRender [

	super removeRender.
	innerCircle := nil
]

{ #category : 'connecting' }
OPBPMNIntermediateEventShape >> renderShapeDetails [

	| label |
	label := RSLabeled new.
	label location below.
	label shapeBuilder labelShape color: Color black.
	roassalShape addInteraction: label.

	icon := RSBitmap new
		        form: self typeIconForModel;
		        yourself.
	self canvas add: icon.
	RSLocation new stick: icon on: self roassalShape.

	innerCircle := RSCircle new
		               size: 31;
		               borderColor: Color black;
		               color: Color transparent;
		               yourself.
	self canvas add: innerCircle.
	RSLocation new stick: innerCircle on: self roassalShape
]
