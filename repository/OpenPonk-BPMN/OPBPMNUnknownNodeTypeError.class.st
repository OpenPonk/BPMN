"
Signals that a requested node type is not supported or recognized by the receiving BPMN model element or view model when resolving type-specific resources such as icons.
"
Class {
	#name : 'OPBPMNUnknownNodeTypeError',
	#superclass : 'Error',
	#instVars : [
		'nodeType'
	],
	#category : 'OpenPonk-BPMN-Models',
	#package : 'OpenPonk-BPMN',
	#tag : 'Models'
}

{ #category : 'signaling' }
OPBPMNUnknownNodeTypeError class >> signalForType: aNodeType [
	^ self new
		nodeType: aNodeType;
		signal: 'Unknown type: ' , aNodeType asString
]

{ #category : 'accessing' }
OPBPMNUnknownNodeTypeError >> nodeType [
	^ nodeType
]

{ #category : 'accessing' }
OPBPMNUnknownNodeTypeError >> nodeType: aNodeType [
	nodeType := aNodeType
]
