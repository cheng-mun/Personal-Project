from collections import deque
from math import inf

'''
QUESTION 1
'''


class Vertex:
    """
    This class represents a vertex of the flow/residual network.

    Attributes:
        id: Unique identifier of the vertex.
        fedges: List of forward edges connecting this vertex to others.
        redges: List of residual edges, created automatically.
        visited: Tracks if the vertex was visited during a search.
        parent: Stores the previous vertex in a path for traversal.
    """

    def __init__(self, id):
        """
        This function creates a vertex with a unique ID.

        :Input:
            id: Integer representing the vertex's unique ID.

        :Time Complexity: O(1)
        :Space Complexity: O(1)
        """
        self.id = id
        self.fedges = []  # flow network edges
        self.redges = []  # residual network edges
        self.visited = False
        self.parent = None


class FEdge:
    """
    This class represents an outgoing edge in the flow network.

    Attributes:
        u: Outgoing vertex.
        v: Receiving vertex.
        capacity: Maximum capacity of the edge.
        lower_bound: Minimum required flow (default is 0).
        flow: Current flow assigned to this edge.
    """

    def __init__(self, u, v, capacity, lower_bound=0):
        """
        This function creates a flow edge between two vertices with a defined capacity.

        :Input:
            u: Outgoing vertex.
            v: Receiving vertex.
            capacity: Maximum flow the edge can carry.
            lower_bound: Minimum guaranteed flow (default is 0).

        :Time Complexity: O(1)
        :Space Complexity: O(1)
        """
        self.u = u
        self.v = v
        self.capacity = capacity
        self.lower_bound = lower_bound
        self.flow = lower_bound


class REdge:
    """
    Represents a residual edge in the residual network.

    Attributes:
        fedge: Corresponding forward edge in the flow network.
        direction: Determine if it is forward or backward edge.
        capacity: Remaining flow capacity.
    """
    forward = 1
    backward = -1

    def __init__(self, fedge, direction):
        """
        This function creates a residual edge based on a flow edge.

        :Input:
            fedge: Reference to the forward edge.
            direction: Indicates if it's a forward or backward edge. (1 = forward, -1 = backward)

        :Time Complexity: O(1)
        :Space Complexity: O(1)
        """
        self.fedge = fedge
        self.direction = direction

        # calculate the residual capacity using flow network capacity and flow according to whether the edge is forward
        # or backward
        if self.direction == self.forward:
            self.capacity = self.fedge.capacity - self.fedge.flow
        else:
            self.capacity = self.fedge.flow - self.fedge.lower_bound

    def other_vertex(self, vertex):
        """
        This function returns the opposite vertex connected by this edge.

        :Input:
            vertex: One of the vertex connected by the edge.

        :Output:
            self.fedge.u/v: The vertex on the other end of the edge.

        :Time Complexity: O(1)
        :Space Complexity: O(1)
        """
        if vertex == self.fedge.u:
            return self.fedge.v
        else:
            return self.fedge.u


class Graph:
    """
    This class represents a flow network with vertices and edges.

    Attributes:
        ids: List of vertex IDs.
        vertices: Adjacency list storing Vertex objects.
        flow_edges: List of flow edges in the graph.
    """

    def __init__(self, V):
        """
        This function initializes a graph with a list of vertices.

        :Input:
            V: List of vertex IDs.

        :Time Complexity: O(V), where V is the number of vertices.
        :Space Complexity: O(V)
        """
        self.ids = V
        self.vertices = []
        for v in V:
            self.vertices.append(Vertex(v))
        self.flow_edges = []

    def get_index(self, id):
        """
        This function finds the index of a vertex based on its ID.

        :Input:
            id: Integer representing the unique ID of the vertex.

        :Output:
            i: Integer index of the vertex in the list.

        :Time Complexity: O(V), where V is the number of vertices.
        :Space Complexity: O(1)
        """
        for i in range(len(self.ids)):
            if self.ids[i] == id:
                return i

    def get_vertex(self, id):
        """
        This function finds and returns a vertex by its ID.

        :Input:
            id: Integer ID of the vertex.

        :Output:
            v: Vertex object with the matching ID.

        :Time Complexity: O(V), where V is the number of vertices.
        :Space Complexity: O(1)
        """
        for v in self.vertices:
            if v.id == id:
                return v

    def add_edge(self, u_id, v_id, capacity, lower_bound=0):
        """
        This function adds a flow edge between two vertices.

        :Input:
            u_id: ID of the outgoing vertex.
            v_id: ID of the receiving vertex.
            capacity: Maximum capacity of the edge.
            lower_bound: Minimum guaranteed flow.

        :Time Complexity: O(V), where V is the number of edges
        :Space Complexity: O(1)
        """
        u = self.get_vertex(u_id)
        v = self.get_vertex(v_id)
        fedge = FEdge(u, v, capacity, lower_bound)
        u.fedges.append(fedge)
        self.flow_edges.append(fedge)

    def bfs(self, source_id, sink_id):
        """
        This function uses Breadth First Search(BFS) to find an augmenting path in the residual network.

        :Input:
            source_id: ID of the source vertex.
            sink_id: ID of the sink vertex.

        :Output:
            sink.visited: Boolean indicating if there is a path from source to sink.

        :Time Complexity: O(V + E), where E is the number of edges, V is the number of vertices.

        :Time Complexity Analysis:
        The BFS traversal explores each vertex once and processes all outgoing edges. Since each edge is considered only
        once during traversal, the time complexity is O(V + E).

        :Space Complexity: O(V), where V is the number of vertices.
        Space Complexity Analysis:
        The function uses a queue to store vertices, which at most contains V items. Additionally, the residual edges
        are stored and updated for each vertex, so O(V) + O(V) = O(V).
        """
        # reset the information of the vertices every time bfs is run
        for v in self.vertices:
            v.visited = False
            v.parent = None
            v.redges = []

        # iterate through flow edges of the graph and create residual edges following constraints
        for fe in self.flow_edges:
            u, v = fe.u, fe.v
            if fe.capacity > fe.flow:
                u.redges.append(REdge(fe, REdge.forward))
            if fe.flow > fe.lower_bound:
                v.redges.append(REdge(fe, REdge.backward))

        source = self.get_vertex(source_id)
        sink = self.get_vertex(sink_id)

        # create queue to store the vertices, starting with the source
        queue = deque()
        queue.append(source)
        source.visited = True

        # iterate through the vertices of the queue and check its residual edges to find other connected vertices
        while len(queue) > 0:
            u = queue.popleft()
            for re in u.redges:
                v = re.other_vertex(u)
                # only update the attribute of the founded vertex and add it to the queue if it hasn't been visited
                # and has a residual capacity > 0
                if not v.visited and re.capacity > 0:
                    v.visited = True
                    v.parent = re
                    queue.append(v)
        # finally, return the visit state of the sink which indicates if there is an augmenting path
        return sink.visited

    def ford_fulkerson(self, source_id, sink_id):
        """
        This function implements the Ford-Fulkerson method to compute max flow.

        :Input:
            source_id: ID of the source vertex.
            sink_id: ID of the sink vertex.

        :Output:
            max_flow: Maximum flow value.

        :Time Complexity: O(E * F), where E is the number of edges and F is the maximum flow.

        :Time Complexity Analysis:
        The function finds an augmenting path calling BFS, which takes O(V + E) time. Since there can be at most F
        augmenting path (where F can be up to N, the number of students), the total time complexity is O(E * F).

        :Space Complexity: O(V)
        :Space Complexity Analysis:
        The function stores vertex data, such as visited and parent attributes, which requires O(V) space.
        Also, the BFS queue maintains active nodes during traversal, contributing another O(V). Since residual
        edges are dynamically updated but do not increase storage beyond O(V + E), the dominant factor remains O(V).
        """
        max_flow = 0

        # While there is an augmenting path, initialize the path flow as infinite
        # then begin travelling from the sink to determine the bottleneck capacity
        while self.bfs(source_id, sink_id) is True:
            path_flow = inf
            v = self.get_vertex(sink_id)

            # Travel the path from sink to source through the parent attribute of the vertices
            # and update path_flow with the minimum residual capacity
            while v.id != source_id:
                re = v.parent
                path_flow = min(path_flow, re.capacity)
                v = re.other_vertex(v)

            # Using the new path flow, travel back from sink to source
            # and update the flow values along the way accordingly
            v = self.get_vertex(sink_id)
            while v.id != source_id:
                re = v.parent
                if re.direction == REdge.forward:
                    re.fedge.flow += path_flow
                else:
                    re.fedge.flow -= path_flow
                v = re.other_vertex(v)
            # Add the current path's flow value to the total maximum flow
            max_flow += path_flow

        return max_flow


def crowdedCampus(n, m, timePreferences, proposedClasses, minimumSatisfaction):
    """
    Function Description:
    This function assigns students to classes while ensuring a minimum number receive one of their preferred time slots.
    If enough students get their top 5 preferred class, the function returns the allocation; otherwise, it returns None.

    Approach Description:
    A flow network is created where students and classes are represented as vertices. Then, the minimum satisfaction
    number of students are assigned to their top 5 preferred classes, while the rest of the students can be allocated to
    classes that are not in their top 5. To remove the demand, a super-source and super-sink is created to handle demand
    balance. After the removal of the demand, the Ford-Fulkerson function under graph class can be used to find the
    maximum flow which is then used to determine class assignments. Finally, verify if the number of satisfied students
    meets minimumSatisfaction before returning the allocation. Otherwise, if the threshold is not met, return None to
    represent impossible allocation.

    Generalised Description of assignment approach:
    The function uses a flow network represented by a graph to allocate students to classes while ensuring a minimum
    satisfaction level. Classes are connected to the sink, while minimumSatisfaction students are linked to the source
    and their top 5 preferred classes. The rest of the students are connected to any available class.
    To balance constraints, a demand adjacency list is created, removing lower-bound restrictions. If there is an
    imbalance in flow, super-source and super-sink nodes are created to balance excess demand. Then, the ford
    fulkerson function with bfs finds augmenting paths in the graph. If the maximum flow is not enough, the function
    returns None.
    If enough students get their top 5 preferred classes, the function creates an allocation list by iterating through
    flow edges of student vertices. When a flow of 1 is found, the default -1 in the allocation list is updated to the
    assigned class ID. If this class matches a top 5 preference, the satisfaction count increases. Finally, there is a
    final check of whether at least minimumSatisfaction students are satisfied. If it is, allocation list is returned.
    Otherwise, the function returns None, meaning an assignment is not possible. The data structure that stores the
    most items is the graph and demand list, which are both implemented as adjacency list to keep it efficient when
    retrieving items.

    :Input:
        n: Number of students.
        m: Number of proposed classes.
        timePreferences: List of lists where each student has five preferred time slots.
        proposedClasses: List of tuples (time_slot, min_capacity, max_capacity).
        minimumSatisfaction: Minimum number of students who must get a preferred class.

    :Output:
        allocation: List representing student-class assignments OR None if conditions can't be met.

    :Time Complexity: O(E * n), where E is the number of edges and n is the number of students.
    :Time Complexity Analysis:
    Each BFS call to find an augmenting path takes O(V + E) time. Since at most n units of flow can be pushed
    (one per student), the total number of iterations is at most n. Therefore, the overall time complexity
    is O(E * n) in the worst case.

    :Space Complexity: O(V + E), where V is the number of vertices.
    :Space Complexity Analysis:
    The graph includes all students, classes, and extra nodes (source, sink, super-source, super-sink), so the number
    of vertices is V = n + m + 4. Information of each edge is stored, resulting in O(E) space.
    Also, the BFS queue and other structures also take O(V), so the total space occupied is O(V + E).
    """

    # Special index in the network to represent the four extra nodes outside of student and classes
    total_vertices = n + m + 4
    source = n + m
    sink = n + m + 1
    super_source = n + m + 2
    super_sink = n + m + 3

    # create the graph with space enough for the extra vertices
    graph = Graph(list(range(total_vertices)))

    # add flow edges from classes to sink based on their capacity constraints
    for class_idx in range(m):
        time_slot, min_cap, max_cap = proposedClasses[class_idx]
        class_vertex = n + class_idx
        graph.add_edge(class_vertex, sink, max_cap, min_cap)

    # connect students to source and their top 5 preferred classes for the minimum satisfaction of students
    for student in range(minimumSatisfaction):
        graph.add_edge(source, student, 1, 1)
        top5 = []
        for i in range(5):
            top5.append(timePreferences[student][i])

        for class_idx in range(m):
            time_slot, _, _ = proposedClasses[class_idx]
            class_vertex = n + class_idx

            if time_slot in top5:
                graph.add_edge(student, class_vertex, 1, 0)

    # after the minimum satisfaction is satisfied, connect the rest of the students to any class
    for student in range(minimumSatisfaction, n):
        graph.add_edge(source, student, 1, 1)
        for class_idx in range(m):
            time_slot, _, _ = proposedClasses[class_idx]
            class_vertex = n + class_idx
            graph.add_edge(student, class_vertex, 1, 0)

    # Compute demand balances and adjust network with super-source and super-sink
    demand = [0] * len(graph.vertices)

    for e in graph.flow_edges:
        demand[graph.get_index(e.v.id)] += e.lower_bound
        demand[graph.get_index(e.u.id)] -= e.lower_bound

    total_positive_demand = 0
    nonzero_demand = False

    # Calculate total positive demand to determine if there is imbalance
    for d in demand:
        if d != 0:
            nonzero_demand = True
            if d > 0:
                total_positive_demand += d

    # Add super-source and super-sink if there is demand imbalance
    if nonzero_demand is True:
        for u in range(len(demand)):
            du = demand[u]
            # if demand is positive, it requires more flow, so an edge is created from super source to the vertex
            if du > 0:
                graph.add_edge(super_source, u, du)
                for v in range(len(demand)):
                    dv = demand[v]
                    if dv < 0:
                        # ensure these helper edges are not added between student and classes as they have constraints
                        if not (u < n or n <= u < n + m or v < n or n <= v < n + m):
                            graph.add_edge(u, v, inf, 0)
            # if demand is negative, it has excess flow, an edge is added to the super sink to absorb the excess
            elif du < 0:
                graph.add_edge(u, super_sink, -du)
        # update the source and sink with super source and super sink
        source, sink = super_source, super_sink

    # Compute maximum flow
    max_flow = graph.ford_fulkerson(source, sink)

    # If flow is insufficient, return None
    if max_flow < total_positive_demand:
        return None

    # Assign students to classes based on the max_flow
    allocation = [-1] * n
    satisfied_count = 0

    # update the allocation and the satisfaction count
    for student in range(n):
        top5 = []
        for i in range(5):
            top5.append(timePreferences[student][i])

        for fe in graph.get_vertex(student).fedges:
            if fe.flow == 1:
                class_idx = fe.v.id - n
                allocation[student] = class_idx
                if proposedClasses[class_idx][0] in top5:
                    satisfied_count += 1
                break

    # If satisfaction count is not enough, return None
    if satisfied_count < minimumSatisfaction:
        return None

    return allocation

