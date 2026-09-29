"
I am the abstract base ViewModel for BPMN flows, bridging the underlying flow models with their canvas representations and lifecycle management.
"
Class {
	#name : 'OPBPMNAbstractFlowViewModel',
	#superclass : 'OPBPMNEdgeViewModel',
	#category : 'OpenPonk-BPMN-ViewModels',
	#package : 'OpenPonk-BPMN',
	#tag : 'ViewModels'
}

{ #category : 'construction' }
OPBPMNAbstractFlowViewModel >> attachModelFrom: sourceViewModel to: targetViewModel [
	self model source: sourceViewModel model.
	self model target: targetViewModel model.
	sourceViewModel model addFlow: self model.
	targetViewModel model addFlow: self model.
]

{ #category : 'private' }
OPBPMNAbstractFlowViewModel >> basicRemoveModel [

	self model target removeFlow: self model.
	self model source removeFlow: self model.
	super basicRemoveModel
]

{ #category : 'construction' }
OPBPMNAbstractFlowViewModel >> registerModelIn: aParentModel [
	"do nothing"
]
