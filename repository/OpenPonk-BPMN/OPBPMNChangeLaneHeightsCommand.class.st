Class {
	#name : 'OPBPMNChangeLaneHeightsCommand',
	#superclass : 'OPCommand',
	#instVars : [
		'firstLaneShape',
		'secondLaneShape',
		'firstLaneOldHeight',
		'firstLaneNewHeight',
		'secondLaneOldHeight',
		'secondLaneNewHeight'
	],
	#category : 'OpenPonk-BPMN-Commands',
	#package : 'OpenPonk-BPMN',
	#tag : 'Commands'
}

{ #category : 'instance creation' }
OPBPMNChangeLaneHeightsCommand class >> firstLaneShape: aFirstLaneShape secondLaneShape: aSecondLaneShape delta: aNumber [
	^ self new
		initializeWithFirstLaneShape: aFirstLaneShape
		secondLaneShape: aSecondLaneShape
		delta: aNumber
]

{ #category : 'accessing' }
OPBPMNChangeLaneHeightsCommand >> defaultDescription [
	^ 'Move Lane Separator'
]

{ #category : 'executing' }
OPBPMNChangeLaneHeightsCommand >> execute [
	firstLaneShape laneHeight: firstLaneNewHeight.
	secondLaneShape laneHeight: secondLaneNewHeight.
	self updatePool
]

{ #category : 'initialization' }
OPBPMNChangeLaneHeightsCommand >> initializeWithFirstLaneShape: aFirstLaneShape secondLaneShape: aSecondLaneShape delta: aNumber [

	firstLaneShape := aFirstLaneShape.
	secondLaneShape := aSecondLaneShape.
	firstLaneOldHeight := aFirstLaneShape laneHeight.
	firstLaneNewHeight := firstLaneOldHeight + aNumber.
	secondLaneOldHeight := aSecondLaneShape laneHeight.
	secondLaneNewHeight := secondLaneOldHeight ifNotNil: [ secondLaneOldHeight - aNumber ]
]

{ #category : 'executing' }
OPBPMNChangeLaneHeightsCommand >> undo [
	firstLaneShape laneHeight: firstLaneOldHeight.
	secondLaneShape laneHeight: secondLaneOldHeight.
	self updatePool
]

{ #category : 'execution' }
OPBPMNChangeLaneHeightsCommand >> updatePool [
	firstLaneShape owningElement ifNotNil: [ :poolDiagramElement |
		poolDiagramElement isRendered ifTrue: [
			poolDiagramElement relocateLanesDisplacingElements: false ] ]
]
