-- define the PriorityQueue class
local PriorityQueue = {}

-- create a new priority queue object
function PriorityQueue:new()
    local pq = { heap = {}, size = 0 }
    setmetatable(pq, { __index = PriorityQueue })
    return pq
end

-- get the parent index of the given index
function PriorityQueue:getParentIndex(index)
    return math.floor(index / 2)
end

-- get the left child index of the given index
function PriorityQueue:getLeftChildIndex(index)
    return 2 * index
end

-- get the right child index of the given index
function PriorityQueue:getRightChildIndex(index)
    return 2 * index + 1
end

-- swap the values at the given indices in the heap
function PriorityQueue:swap(index1, index2)
    self.heap[index1], self.heap[index2] = self.heap[index2], self.heap[index1]
end

-- bubble up the value at the given index in the heap
function PriorityQueue:bubbleUp(index)
    local parentIndex = self:getParentIndex(index)
    if parentIndex > 0 and self.heap[index].priority < self.heap[parentIndex].priority then
        self:swap(index, parentIndex)
        self:bubbleUp(parentIndex)
    end
end

-- bubble down the value at the given index in the heap
function PriorityQueue:bubbleDown(index)
    local leftChildIndex = self:getLeftChildIndex(index)
    local rightChildIndex = self:getRightChildIndex(index)
    local smallestIndex = index

    if leftChildIndex <= self.size and self.heap[leftChildIndex].priority < self.heap[smallestIndex].priority then
        smallestIndex = leftChildIndex
    end

    if rightChildIndex <= self.size and self.heap[rightChildIndex].priority < self.heap[smallestIndex].priority then
        smallestIndex = rightChildIndex
    end

    if smallestIndex ~= index then
        self:swap(index, smallestIndex)
        self:bubbleDown(smallestIndex)
    end
end

-- add a new value to the priority queue
function PriorityQueue:push(value, priority)
    local item = { value = value, priority = priority }
    self.size = self.size + 1
    self.heap[self.size] = item
    self:bubbleUp(self.size)
end

-- remove and return the highest-priority value from the priority queue
function PriorityQueue:pop()
    local highestPriorityItem = self.heap[1]
    self.heap[1] = self.heap[self.size]
    self.heap[self.size] = nil
    self.size = self.size - 1
    self:bubbleDown(1)
    return highestPriorityItem.value
end

-- get the highest-priority value from the priority queue without removing it
function PriorityQueue:peek()
    return self.heap[1].value
end

-- check if the priority queue is empty
function PriorityQueue:isEmpty()
    return self.size == 0
end

return PriorityQueue