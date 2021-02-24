Class {
	#name : #OPBPMNIcon,
	#superclass : #Object,
	#instVars : [
		'icons'
	],
	#classVars : [
		'Current'
	],
	#category : #'OpenPonk-BPMN-Icons'
}

{ #category : #accessing }
OPBPMNIcon class >> current [
	^ Current ifNil: [ Current := self new ]
]

{ #category : #initialization }
OPBPMNIcon >> activity [
	^ Form
		fromBinaryStream: (self activityContent base64Decoded asByteArray readStream)
]

{ #category : #initialization }
OPBPMNIcon >> activityContent [
	^ 'iVBORw0KGgoAAAANSUhEUgAAABEAAAARCAYAAAA7bUf6AAAAAXNSR0IArs4c6QAAAAlwSFlzAAALEwAACxMBAJqcGAAAAVlpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IlhNUCBDb3JlIDUuNC4wIj4KICAgPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4KICAgICAgPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIKICAgICAgICAgICAgeG1sbnM6dGlmZj0iaHR0cDovL25zLmFkb2JlLmNvbS90aWZmLzEuMC8iPgogICAgICAgICA8dGlmZjpPcmllbnRhdGlvbj4xPC90aWZmOk9yaWVudGF0aW9uPgogICAgICA8L3JkZjpEZXNjcmlwdGlvbj4KICAgPC9yZGY6UkRGPgo8L3g6eG1wbWV0YT4KTMInWQAAARRJREFUOBGtkz9OAkEUh3cBE62JiQnxEhrDBcDCq3ABQ0FhbecZvACtnIFTGBIJBcbCRoHvG3gEElQG+SXfzs68P/tm9k1RLFVdjblDiiuJqsAMzuEKXNtHQ5zGUEZAh0kPRvCtAX7SHIMfvoQHeIKiDR9w4yRD1/i+w617eoQ+PEMN3NpfOsHhFc7gzrJ8eYND5JmcmsQ9WkGOjFHp75jEQ4xFDTlKcSb5t46WxJJ+64tdlYZ/Gj1QX75WnlvGXdGsbZ6fcaVJPuECVPTIpuPSsv0Mu3HGFy2w85pOMmSHT6FtJQO4B7s27k70D0tJbjO+7mh/NKALLxoNcBt18D5EQJwPS2uZIOze4gms/7AVHaIUtwBfLy8Zr5ir1gAAAABJRU5ErkJggg=='
]

{ #category : #initialization }
OPBPMNIcon >> endEvent [
	^ Form
		fromBinaryStream: (self endEventContent base64Decoded asByteArray readStream)
]

{ #category : #initialization }
OPBPMNIcon >> endEventContent [
	^ 'iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAAAXNSR0IArs4c6QAAAAlwSFlzAAALEwAACxMBAJqcGAAAAVlpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IlhNUCBDb3JlIDUuNC4wIj4KICAgPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4KICAgICAgPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIKICAgICAgICAgICAgeG1sbnM6dGlmZj0iaHR0cDovL25zLmFkb2JlLmNvbS90aWZmLzEuMC8iPgogICAgICAgICA8dGlmZjpPcmllbnRhdGlvbj4xPC90aWZmOk9yaWVudGF0aW9uPgogICAgICA8L3JkZjpEZXNjcmlwdGlvbj4KICAgPC9yZGY6UkRGPgo8L3g6eG1wbWV0YT4KTMInWQAAAVVJREFUOBGNk9sqRVEUhue2xX4ClFxJihRJeBl5C4dyr+yTJ5AnUFK7nHLhRuJKrrjlBYiE7fvN+a/Wwt7561vjMOcYa615KIWoHsxn8iewy7AIA6D8I5zDLtyDlNXIsTZx3qHdgVfyG2Dla8MeWRe+4LegBlU4hHzjHeKC6kQuPsEfL4zGYBZzBZ636jnTueSRk9gy9CbkS31wDWryBCMQtkEJffYYSP3RFJ6VFM1hP0A168pdpOBAAfLbYlR8etHOSKtBS4lBkG6iCaVk/zJucJsGh5VQJ8k2Rv97ttVAh0TSAZK6NfJhm4pTw4Os9llFzzAKUrdFXGBcjVSzBkHdvKo6MJa+ztvof1fss5BtowpqoI7iFPw7uJlm8C7B81aykeTs5wbf8HWomtCAY+h4lP15zAlbPyb6bba/LpP3XE28wpP4SzAPQyBpp3yd774z6Tp/AQmNZMmz6AeSAAAAAElFTkSuQmCC'
]

{ #category : #initialization }
OPBPMNIcon >> initialize [
	super initialize.
	self initializeIcons
]

{ #category : #initialization }
OPBPMNIcon >> initializeIcons [
	icons := LRUCache new
		maximumWeight: 64;
		factory: [ :key | self perform: key ];
		yourself
]

{ #category : #initialization }
OPBPMNIcon >> sequenceFlow [
	^ Form
		fromBinaryStream: (self sequenceFlowContent base64Decoded asByteArray readStream)
]

{ #category : #initialization }
OPBPMNIcon >> sequenceFlowContent [
	^ 'iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAAAXNSR0IArs4c6QAAAARnQU1B
AACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAApSURBVDhPYxgF9Af/oTRFAGQI1QwC
A5iJ5GKyAdmaKbKZIicPT8DAAADJtBfpwGY0agAAAABJRU5ErkJggg=='
]

{ #category : #initialization }
OPBPMNIcon >> startEvent [
	^ Form
		fromBinaryStream: (self startEventContent base64Decoded asByteArray readStream)
]

{ #category : #initialization }
OPBPMNIcon >> startEventContent [
	^ 'iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABmJLR0QA/wD/AP+gvaeTAAAA
CXBIWXMAAAsTAAALEwEAmpwYAAAAB3RJTUUH3gwREQMGFh81tQAAABl0RVh0Q29tbWVudABD
cmVhdGVkIHdpdGggR0lNUFeBDhcAAACSSURBVDjLrdO9DcJADIbhR4QG6QbJEvQZAIpscHuk
YpX02SEFy6SlCY1pgBDy80purE/32WebTxJqdBgiusglM9QY0SOjjMiRG0PzlSYE+YdBDk0z
5VyZp3qvJP3hPFVJern3ltOjLnBDi/vCB464ijGVKyooMRxspMAZjxUtXHDa/Im7jHHzIu2y
yrsc06pzfgKTTTJXZ7zJ7gAAAABJRU5ErkJggg=='
]
