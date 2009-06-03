<%
/**
 * Copyright (c) 2000-2009 Liferay, Inc. All rights reserved.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */
%>

<%@ include file="/html/taglib/ui/asset_categories_navigation/init.jsp" %>

<%
long categoryId = ParamUtil.getLong(renderRequest, "categoryId");

List<AssetCategoryVocabulary> vocabularies = null;

vocabularies = AssetCategoryVocabularyServiceUtil.getGroupCategoryVocabularies(scopeGroupId);

PortletURL portletURL = renderResponse.createRenderURL();
%>

<liferay-ui:panel-container id='<%= namespace + "taglibAssetCategoriessNavigation" %>' extended="<%= Boolean.TRUE %>" persistState="<%= true %>" cssClass="taglib-asset-categories-navigation">

	<%
	for (int i = 0; i < vocabularies.size(); i++) {
		AssetCategoryVocabulary vocabulary = vocabularies.get(i);

		String vocabularyName = vocabulary.getName();
	%>

		<c:choose>
			<c:when test="<%= vocabularies.size() == 1 %>">
				<%= _buildVocabularyNavigation(vocabulary, categoryId, portletURL) %>
			</c:when>
			<c:otherwise>
				<liferay-ui:panel id='<%= namespace + "taglibAssetCategoriesNavigation" + i %>' title="<%= vocabularyName %>" collapsible="<%= false %>" persistState="<%= true %>" extended="<%= true %>">
					<%= _buildVocabularyNavigation(vocabulary, categoryId, portletURL) %>
				</liferay-ui:panel>
			</c:otherwise>
		</c:choose>
	<%
	}
	%>

</liferay-ui:panel-container>

<script type="text/javascript">
	jQuery(document).ready(
		function() {
			var treeview = jQuery('#<%= namespace %>taglibAssetCategoriessNavigation .treeview');

			if (treeview.treeview) {
				treeview.treeview(
					{
						animated: 'fast'
					}
				);

				jQuery.ui.disableSelection(treeview);
			}
		}
	);
</script>

<%!
private void _buildCategoriesNavigation(List<AssetCategory> categories, long curCategoryId, PortletURL portletURL, StringBuilder sb) throws Exception {
	for (AssetCategory category : categories) {
		long categoryId = category.getCategoryId();
		String name = category.getName();

		List<AssetCategory> categoriesChildren = AssetCategoryServiceUtil.getChildCategories(category.getCategoryId());

		sb.append("<li>");
		sb.append("<span>");

		if (categoryId == curCategoryId) {
			sb.append("<b>");
			sb.append(name);
			sb.append("</b>");
		}
		else {
			portletURL.setParameter("categoryId", String.valueOf(categoryId));

			sb.append("<a href=\"");
			sb.append(portletURL.toString());
			sb.append("\">");
			sb.append(name);
			sb.append("</a>");
		}

		sb.append("</span>");

		if (!categoriesChildren.isEmpty()) {
			sb.append("<ul>");

			_buildCategoriesNavigation(categoriesChildren, curCategoryId, portletURL, sb);

			sb.append("</ul>");
		}

		sb.append("</li>");
	}
}

private String _buildVocabularyNavigation(AssetCategoryVocabulary vocabulary, long categoryId, PortletURL portletURL) throws Exception {
	StringBuilder sb = new StringBuilder();

	sb.append("<ul class=\"treeview\">");

	List<AssetCategory> categories = AssetCategoryServiceUtil.getVocabularyRootCategories(vocabulary.getCategoryVocabularyId());

	_buildCategoriesNavigation(categories, categoryId, portletURL, sb);

	sb.append("</ul>");
	sb.append("<br style=\"clear: both;\" />");

	return sb.toString();
}
%>