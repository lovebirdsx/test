type EventNames = 'click' | 'scroll' | 'mousemove'
function handleEvent(e: Element, event: EventNames) {

}

handleEvent(document.getElementById('hello'), 'scroll')

// event不能为dbclick类型
// handleEvent(document.getElementById('world'), 'dbclick')
