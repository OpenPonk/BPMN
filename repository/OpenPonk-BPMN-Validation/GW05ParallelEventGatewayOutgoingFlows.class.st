Class {
	#name : 'GW05ParallelEventGatewayOutgoingFlows',
	#superclass : 'OPBPMNValidation',
	#category : 'OpenPonk-BPMN-Validation-Validation-Classes',
	#package : 'OpenPonk-BPMN-Validation',
	#tag : 'Validation-Classes'
}

{ #category : 'as yet unclassified' }
GW05ParallelEventGatewayOutgoingFlows class >> validateClass [
	^ OPBPMNGatewayModel.
]

{ #category : 'verification' }
GW05ParallelEventGatewayOutgoingFlows >> validateObject: aVerifiedObject withModel: aVerifiedModel [
	| counter |
	(aVerifiedObject isKindOf: OPBPMNGatewayModel) ifTrue: [ 
		((aVerifiedObject type = OPBPMNNodeType Parallel) 
	 | (aVerifiedObject type = OPBPMNNodeType Eventbased))
	 ifTrue: [
		counter := 0.
		aVerifiedObject outgoing do: [ :each | (
			(each isKindOf: OPBPMNFlowModel) ifTrue: [ (each name ~= '') | (each type = 'Conditional')
				ifTrue: [  counter := 1 ]]) ] ].
		counter = 1 ifTrue: [ 
		 
				^ { (OPBPMNValidationMessageError
					   createFor: aVerifiedObject
					   withValidation: self
					   withText: '(GW05) ', aVerifiedObject class name
						   ,
						   ' of type Parallel/Eventbased should not have conditional and labeled outgoing flows') } ] ].
	^ {  }
]
