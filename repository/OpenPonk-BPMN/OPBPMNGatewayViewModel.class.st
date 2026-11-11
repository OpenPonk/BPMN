"
I map the underlying BPMN Gateway model to its UI representation and configure form properties for branching logic.
"
Class {
	#name : 'OPBPMNGatewayViewModel',
	#superclass : 'OPBPMNSemanticNodeViewModel',
	#category : 'OpenPonk-BPMN-ViewModels',
	#package : 'OpenPonk-BPMN',
	#tag : 'ViewModels'
}

{ #category : 'accessing' }
OPBPMNGatewayViewModel class >> modelClass [ ^ OPBPMNGatewayModel
]

{ #category : 'forms' }
OPBPMNGatewayViewModel >> buildEditorForm: aForm [

	| droplist |
	super buildEditorForm: aForm.
	droplist := aForm
		bindDroplist: 'Type'
		property: #type
		items: #( #'Exclusive (empty)' #Exclusive #Inclusive #Parallel #Complex #Eventbased ).
	droplist displayIcon: [ :eachGatewayType | self typeIconFor: eachGatewayType ].
	droplist display: [ :eachGatewayType | eachGatewayType asString ]
]

{ #category : 'accessing' }
OPBPMNGatewayViewModel >> icon [ ^ OPBPMNIcon current gateway
]

{ #category : 'forms' }
OPBPMNGatewayViewModel >> typeIconFor: aType [
	aType = OPBPMNNodeType ExclusiveEmpty ifTrue: [
		^ Smalltalk ui theme iconNamed: #empty ].
	aType = OPBPMNNodeType Parallel ifTrue: [
		^ OPBPMNIcon current gatewayParallel ].
	aType = OPBPMNNodeType Inclusive ifTrue: [
		^ OPBPMNIcon current gatewayInclusive ].
	aType = OPBPMNNodeType Exclusive ifTrue: [
		^ OPBPMNIcon current gatewayExclusive ].
	aType = OPBPMNNodeType Complex ifTrue: [
		^ OPBPMNIcon current gatewayComplex ].
	aType = OPBPMNNodeType Eventbased ifTrue: [
		^ OPBPMNIcon current gatewayEvent ].
	^ super typeIconFor: aType
]
