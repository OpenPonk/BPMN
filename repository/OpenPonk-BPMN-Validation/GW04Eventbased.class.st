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
	(aVerifiedObject isKindOf: OPBPMNGatewayModel)
	& (aVerifiedObject type = OPBPMNNodeType Eventbased)
	& (aVerifiedObject outgoing size > 1) ifTrue: [
		counter := 0.
		aVerifiedObject outgoing do: [ :each |
			(each target isKindOf: OPBPMNIntermediateEventModel)
			| (each target isKindOf: OPBPMNActivityModel)
				ifTrue: [
					each target type = OPBPMNNodeType Receive
					| (each target type = OPBPMNNodeType Escalation)
					| (each target type = OPBPMNNodeType Link)
					| (each target type = OPBPMNNodeType Compensation)
					| (each target type = OPBPMNNodeType Signal)
					| (each target type = OPBPMNNodeType Multiple) ifFalse: [ counter := 1 ] ]
				ifFalse: [ counter := 1 ].
			counter = 1 ifTrue: [
				^ { (OPBPMNValidationMessageError
					   createFor: aVerifiedObject
					   withValidation: self
					   withText: '(GW04) ' , aVerifiedObject class name
						   ,
						   ' can have on outgoing flows only Intermediate Catching Events or Receive Task.') } ] ] ].
	^ {  }
]
