Class {
	#name : 'OPBPMNEndEventShape',
	#superclass : 'OPBPMNEventShape',
	#category : 'OpenPonk-BPMN-Shapes',
	#package : 'OpenPonk-BPMN',
	#tag : 'Shapes'
}

{ #category : 'connecting' }
OPBPMNEndEventShape >> createRoassalShape [
	^ RSCircle new
		size: 36;
		borderColor: Color black;
		border: (RSBorder new
		color: (Color black);
		width: 5);
		yourself
]
