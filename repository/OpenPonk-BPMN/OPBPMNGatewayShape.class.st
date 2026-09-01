"
I render a BPMN Gateway as a Roassal bound node, drawing the standard diamond shape and placing inner markers indicating the gateway type.
"
Class {
	#name : 'OPBPMNGatewayShape',
	#superclass : 'OPBPMNNodeShape',
	#category : 'OpenPonk-BPMN-DiagramElements',
	#package : 'OpenPonk-BPMN',
	#tag : 'DiagramElements'
}

{ #category : 'connecting' }
OPBPMNGatewayShape >> createRoassalShape [

	^  RSPolygon new
		points: { 0@24. 24@0. 0@(-24). -24@0. };
		borderColor: Color black;
		yourself.
]

{ #category : 'rendering' }
OPBPMNGatewayShape >> renderShapeDetails [ 
	super renderShapeDetails.
	self color: (Color fromHexString: 'bce2fe').
	"TODO for what are good bounds?????"
	"JanBliznicenko: To persist position and size for persistence"
	"self bounds: nil"
]
