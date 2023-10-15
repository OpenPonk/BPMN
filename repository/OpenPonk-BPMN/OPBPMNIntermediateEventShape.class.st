Class {
	#name : #OPBPMNIntermediateEventShape,
	#superclass : #OPBPMNEventShape,
	#category : #'OpenPonk-BPMN-DiagramElements'
}

{ #category : #connecting }
OPBPMNIntermediateEventShape >> createRoassalShape [
	^ RSCircle new
		size: 39;
		borderColor: Color black;
		yourself
]

{ #category : #connecting }
OPBPMNIntermediateEventShape >> renderShapeDetails [

	| label selectable innerCircle |
	label := RSLabeled new.
	label location below.
	label shapeBuilder labelShape color: Color black.
	roassalShape addInteraction: label.

	icon := RSBitmap new
		        form: self typeIconForModel;
		        yourself.
	self canvas add: icon.
	RSLocation new stick: icon on: self roassalShape.
	self roassalShape
		when: RSShapeRemovedEvent
		do: [ icon remove ]
		for: self.

	innerCircle := RSCircle new
		               size: 31;
		               borderColor: Color black;
		               color: Color transparent;
		               yourself.
	self canvas add: innerCircle.
	RSLocation new stick: innerCircle on: self roassalShape.
	self roassalShape
		when: RSShapeRemovedEvent
		do: [ innerCircle remove ]
		for: self
]
