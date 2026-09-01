"
I provide constant identifiers and enumerations for the various types of BPMN nodes, events, gateways, and markers used throughout the editor to identify semantic element types.
"
Class {
	#name : 'OPBPMNNodeType',
	#superclass : 'Object',
	#category : 'OpenPonk-BPMN-Models',
	#package : 'OpenPonk-BPMN',
	#tag : 'Models'
}

{ #category : 'values' }
OPBPMNNodeType class >> Cancel [
	^ #Cancel
]

{ #category : 'values' }
OPBPMNNodeType class >> CatchCompensation [

	^ #CatchCompensation
]

{ #category : 'values' }
OPBPMNNodeType class >> Compensation [

	^ #Compensation
]

{ #category : 'values' }
OPBPMNNodeType class >> CompensationThrow [

	^ #CompensationThrow
]

{ #category : 'values' }
OPBPMNNodeType class >> Complex [
	^ #Complex
]

{ #category : 'values' }
OPBPMNNodeType class >> Conditional [

	^ #Conditional
]

{ #category : 'values' }
OPBPMNNodeType class >> DataInput [
	^#DataInput
]

{ #category : 'values' }
OPBPMNNodeType class >> DataObject [
	^#DataObject
]

{ #category : 'values' }
OPBPMNNodeType class >> DataOutput [
	^#DataOutput
]

{ #category : 'values' }
OPBPMNNodeType class >> DataStore [
	^#DataStore
]

{ #category : 'values' }
OPBPMNNodeType class >> Error [
	^ #Error
]

{ #category : 'values' }
OPBPMNNodeType class >> Escalation [

	^ #Escalation
]

{ #category : 'values' }
OPBPMNNodeType class >> EscalationThrow [

	^ #EscalationThrow
]

{ #category : 'values' }
OPBPMNNodeType class >> Eventbased [
	^ #Eventbased
]

{ #category : 'values' }
OPBPMNNodeType class >> Exclusive [
	^ #Exclusive
]

{ #category : 'values' }
OPBPMNNodeType class >> ExclusiveEmpty [
	^ #'Exclusive (empty)'
]

{ #category : 'values' }
OPBPMNNodeType class >> Inclusive [
	^ #Inclusive
]

{ #category : 'values' }
OPBPMNNodeType class >> Link [
	^ #Link
]

{ #category : 'values' }
OPBPMNNodeType class >> LinkThrow [
	^ #LinkThrow
]

{ #category : 'values' }
OPBPMNNodeType class >> Manual [
	^ #Manual
]

{ #category : 'values' }
OPBPMNNodeType class >> MarkerAdhoc [
	^ #MarkerAdhoc
]

{ #category : 'values' }
OPBPMNNodeType class >> MarkerCompensation [
	^ #MarkerCompensation
]

{ #category : 'values' }
OPBPMNNodeType class >> MarkerLoop [
	^ #MarkerLoop
]

{ #category : 'values' }
OPBPMNNodeType class >> MarkerParallel [
	^ #MarkerParallel
]

{ #category : 'values' }
OPBPMNNodeType class >> MarkerSequential [
	^ #MarkerSequential
]

{ #category : 'values' }
OPBPMNNodeType class >> MarkerSubProcess [	
	^ #MarkerSubProcess
]

{ #category : 'values' }
OPBPMNNodeType class >> Multiple [

	^ #Multiple
]

{ #category : 'values' }
OPBPMNNodeType class >> MultipleThrow [

	^ #MultipleThrow
]

{ #category : 'values' }
OPBPMNNodeType class >> None [
	^ #None
]

{ #category : 'values' }
OPBPMNNodeType class >> Parallel [
	^ #Parallel
]

{ #category : 'values' }
OPBPMNNodeType class >> ParallelMultiple [

	^ #ParallelMultiple
]

{ #category : 'values' }
OPBPMNNodeType class >> Receive [
	^ #Receive
]

{ #category : 'values' }
OPBPMNNodeType class >> Send [

	^ #Send
]

{ #category : 'values' }
OPBPMNNodeType class >> Service [
	^ #Service
]

{ #category : 'values' }
OPBPMNNodeType class >> Signal [

	^ #Signal
]

{ #category : 'values' }
OPBPMNNodeType class >> SignalThrow [

	^ #SignalThrow
]

{ #category : 'values' }
OPBPMNNodeType class >> Terminate [

	^ #Terminate
]

{ #category : 'values' }
OPBPMNNodeType class >> Timer [
	^ #Timer
]

{ #category : 'values' }
OPBPMNNodeType class >> User [
	^#User
]
