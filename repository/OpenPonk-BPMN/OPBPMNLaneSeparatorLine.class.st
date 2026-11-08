"
Renders a horizontal separator line between adjacent lanes and provides an enlarged hit detection radius for interactive drag gestures.
"
Class {
	#name : 'OPBPMNLaneSeparatorLine',
	#superclass : 'RSLine',
	#category : 'OpenPonk-BPMN-DiagramElements',
	#package : 'OpenPonk-BPMN',
	#tag : 'DiagramElements'
}

{ #category : 'accessing' }
OPBPMNLaneSeparatorLine >> includedRadius [
	^ super includedRadius max: 5
]
