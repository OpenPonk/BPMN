Class {
	#name : #GW04Eventbased,
	#superclass : #OPBPMNValidation,
	#category : #'OpenPonk-BPMN-Validation-Validation-Classes'
}

{ #category : #'as yet unclassified' }
GW04Eventbased class >> validateClass [
	^ OPBPMNGatewayModel.
]

{ #category : #verification }
GW04Eventbased >> validateObject: aVerifiedObject withModel: aVerifiedModel [

	| counter |
	(aVerifiedObject isKindOf: OPBPMNGatewayModel) & aVerifiedObject type
	= OPBPMNNodeType Eventbased 
	ifTrue: [ 
		counter := 0.
		aVerifiedObject outgoing do: [ :each | 
			(each isKindOf: OPBPMNIntermediateEventModel)
			| (each isKindOf: OPBPMNActivityModel)
				ifTrue: [ 
					each type = OPBPMNNodeType Receive
					| (each type = OPBPMNNodeType Escalation)
					| (each type = OPBPMNNodeType Link)
					| (each type = OPBPMNNodeType Compensation)
					| (each type = OPBPMNNodeType Signal)
					| (each type = OPBPMNNodeType Multiple) ifFalse: [ counter := 1 ] ]
				ifFalse: [ counter := 1 ] ] ].
	counter = 1 ifTrue: [ 
		aVerifiedObject type = OPBPMNNodeType Send
		| (aVerifiedObject type = OPBPMNNodeType Multiple) ifFalse: [ 
			^ { (OPBPMNValidationMessageError
				   createFor: aVerifiedObject
				   withValidation: self
				   withText: '(GW04) ' , aVerifiedObject class name
					   ,
					   ' can have on outgoing flows only Intermediate Catching Events or Receive Task.') } ] ].
	^ {  }
]
