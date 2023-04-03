Class {
	#name : #OPBPMNGatewayShape,
	#superclass : #OPBPMNNodeShape,
	#category : #'OpenPonk-BPMN-DiagramElements'
}

{ #category : #connecting }
OPBPMNGatewayShape >> createRoassalShape [

	^  RSPolygon new
		points: { 0@24. 24@0. 0@(-24). -24@0. };
		borderColor: Color black;
		yourself.
]

{ #category : #connecting }
OPBPMNGatewayShape >> renderShapeDetails [ 
	super renderShapeDetails.
	self color: (Color fromHexString: 'bce2fe').
	"TODO for what are good bounds?????"
	self bounds: nil.
]

{ #category : #connecting }
OPBPMNGatewayShape >> typeIconFor: aType [
	aType = OPBPMNNodeType Parallel
		ifTrue: [ ^ OPBPMNIcon current gatewayParallel ].
	aType = OPBPMNNodeType Inclusive
		ifTrue: [ ^ OPBPMNIcon current gatewayInclusive ].
	aType = OPBPMNNodeType Exclusive
		ifTrue: [ ^ OPBPMNIcon current gatewayExclusive ].
	aType = OPBPMNNodeType Complex
		ifTrue: [ ^ OPBPMNIcon current gatewayComplex ].
	aType = OPBPMNNodeType Eventbased
		ifTrue: [ ^ OPBPMNIcon current gatewayEvent ].
	aType = OPBPMNNodeType None
		ifTrue: [ ^ OPBPMNIcon current activityNone ]
]
