import collections

# Grabbed from https://github.com/delfick/python-dict2xml/blob/master/dict2xml/logic.py

########################
# ##   NODE
########################

class Node(object):
    """
        Represents each tag in the tree

        Each node has _either_ a single value or one or more children
        If it has a value:
            The serialized result is <%(tag)s>%(value)s</%(tag)s>

        If it has children:
            The serialized result is
                <%(wrap)s>
                    %(children)s
                </%(wrap)s>

        Which one it is depends on the implementation of self.convert
    """

    # A mapping of characters to treat as escapable entities and their replacements
    entities = [('&', '&amp;'), ('<', '&lt;'), ('>', '&gt;')]

    def __init__(self, wrap="", tag="", data=None):
        self.tag = tag
        self.wrap = wrap
        self.data = data
        self.type = self.determine_type()

        if self.type == 'flat' and isinstance(self.data, basestring):
            # Make sure we deal with entities
            for entity, replacement in self.entities:
                self.data = self.data.replace(entity, replacement)

    def serialize(self, indenter):
        """Returns the Node serialized as an xml string"""
        # Determine the start and end of this node
        wrap = self.wrap
        end, start = "", ""
        if wrap:
            end = "</%s>" % wrap
            start = "<%s>" % wrap

        # Convert the data attached in this node into a value and children
        value, children = self.convert()

        # Determine the content of the node (essentially the children as a string value)
        content = ""
        if children:
            if self.type != "iterable":
                # Non-iterable wraps all it's children in the same tag
                content = indenter((c.serialize(indenter) for c in children), wrap)
            else:
                # Iterables repeat the wrap for each child
                result = []
                for c in children:
                    content = c.serialize(indenter)
                    if c.type == 'flat':
                        # Child with value, it already is surrounded by the tag
                        result.append(content)
                    else:
                        # Child with children of it's own, they need to be wrapped by start and end
                        content = indenter([content], True)
                        result.append(''.join((start, content, end)))

                # We already have what we want, return the indented result
                return indenter(result, False)

        # If here, either:
        #  * Have a value
        #  * Or this node is not an iterable
        return ''.join((start, value, content, end))

    def determine_type(self):
        """
            Return the type of the data on this node as an identifying string

            * Iterable : Supports "for item in data"
            * Mapping : Supports "for key in data: value = data[key]"
            * flat : A string or something that isn't iterable or a mapping
        """
        data = self.data
        if type(data) in (str, unicode):
            return 'flat'
        elif isinstance(data, collections.Mapping):
            return 'mapping'
        elif isinstance(data, collections.Iterable):
            return 'iterable'
        else:
            return 'flat'

    def convert(self):
        """
            Convert data on this node into a (value, children) tuple depending on the type of the data
            If the type is :
                * flat : Use self.tag to surround the value. <tag>value</tag>
                * mapping : Return a list of tags where the key for each child is the wrap for that node
                * iterable : Return a list of Nodes where self.wrap is the tag for that node
        """
        val = ""
        typ = self.type
        data = self.data
        children = []

        if typ == 'mapping':
            for key in sorted(data):
                item = data[key]
                children.append(Node(key, "", item))

        elif typ == 'iterable':
            for item in data:
                children.append(Node("", self.wrap, item))

        else:
            val = unicode(data)
            if self.tag:
                val = "<%s>%s</%s>" % (self.tag, val, self.tag)

        return val, children

########################
# ##   CONVERTER
########################

class Converter(object):
    """Logic for creating a Node tree and serialising that tree into a string"""
    def __init__(self, wrap=None, indent='  ', newlines=True):
        """
            wrap: The tag that the everything else will be contained within
            indent: The string that is multiplied at the start of each new line, to represent each level of nesting
            newlines: A boolean specifying whether we want each tag on a new line.

            Note that indent only works if newlines is True
        """
        self.wrap = wrap
        self.indent = indent
        self.newlines = newlines

    def _make_indenter(self):
        """Returns a function that given a list of strings, will return that list as a single, indented, string"""
        indent = self.indent
        newlines = self.newlines

        if not newlines:
            # No newlines, don't care about indentation
            ret = lambda nodes, wrapped: "".join(nodes)
        else:
            if not indent:
                indent = ""

            def eachline(nodes):
                """Yield each line in each node"""
                for node in nodes:
                    for line in node.split('\n'):
                        yield line

            def ret(nodes, wrapped):
                """
                    Indent nodes depending on value of wrapped and indent
                    If not wrapped, then don't indent
                    Otherwise,
                        Seperate each child by a newline
                        and indent each line in the child by one indent unit
                """
                if wrapped:
                    seperator = "\n%s" % indent
                    surrounding = "\n%s%%s\n" % indent
                else:
                    seperator = "\n"
                    surrounding = "%s"
                return surrounding % seperator.join(eachline(nodes))

        return ret

    def build(self, data):
        """Create a Node tree from the data and return it as a serialized xml string"""
        indenter = self._make_indenter()
        return Node(wrap=self.wrap, data=data).serialize(indenter)
