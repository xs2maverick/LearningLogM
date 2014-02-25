package jp.ac.tokushima_u.is.ll.dao;

import java.util.Collection;
import java.util.Date;
import java.util.List;
import java.util.Map;

import jp.ac.tokushima_u.is.ll.dto.ItemDTO;
import jp.ac.tokushima_u.is.ll.entity.Item;
import jp.ac.tokushima_u.is.ll.entity.Language;
import jp.ac.tokushima_u.is.ll.form.ItemSearchCondForm;
import jp.ac.tokushima_u.is.ll.form.ItemSyncCondForm;

import org.apache.ibatis.annotations.Param;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;

public interface ItemDao {
	List<Map<String, Object>> selectItemWhereHasFile();

	List<Map<String, Object>> countCreatedItemsOnDayByAuthors(Date date);
	List<Map<String, Object>> countCreatedItemsInWeekByAuthors(@Param("start")Date start, @Param("end")Date end);

	Date findMinCreatedTime();

	Item findById(String itemid);
	Item findByIdIgnoreDisableFlg(String itemid);
	ItemDTO findDTOById(String itemid);

	List<Item> findListForMotherLangRecommend(@Param("userId") String userId,
			@Param("studyLangs") List<Language> studyLangs, @Param("myLangs") List<Language> myLangs);

	List<Item> findListForPopularItems(@Param("userId") String userId,
			@Param("studyLangs") List<Language> studyLangs, @Param("myLangs") List<Language> myLangs, @Param("limit") int limit);

	int updateRatingAvg(@Param("itemId")String itemId, @Param("avg")double avg);

	void insert(Item item);
	void update(Item item);

	List<Item> findListWaitItemsThroughItemQueue(@Param("userId")String userId, @Param("startTime")Date startTime);

	List<Item> findListNearestItems(@Param("userId")String userId, @Param("lng")double lng, @Param("lat")double lat,
			@Param("distance")double distance, @Param("pageRequest")Pageable pageRequest);

	List<Item> findListByAuthorNotRelog(String userId);

	List<Item> findListByAuthorOnlyRelog(String userId);

	List<Item> findListByAuthorAndCreatedFromNotRelog(@Param("userId")String userId, @Param("lastDate")Date lastDate);

	List<Item> findListByAuthorInPeriod(@Param("authorId")String authorId, @Param("start")Date start, @Param("end")Date end);

	List<Item> findListByAuthor(@Param("userId")String userId, @Param("sort")Sort sort);

	List<ItemDTO> searchListByCond(@Param("cond")ItemSearchCondForm cond, @Param("page")Pageable pageable);

	Long countByCond(@Param("cond")ItemSearchCondForm cond);

	List<Item> findListBySyncCond(@Param("synccond")ItemSyncCondForm form, @Param("page")Pageable pageable);

	List<Item> findListForNearestItems(@Param("lat")double lat, @Param("lng")double lng, @Param("distance") double distance, @Param("userId")String userId,
			@Param("avoidItemId")String avoidItemId, @Param("page")Pageable pageable);

	List<Item> findListForNearestItemsWithoutNotified(@Param("lat")double lat, @Param("lng")double lng,
			@Param("distance") double distance, @Param("size")int itemSize, @Param("userId") String userId);
	
	List<Item> findListForLatestItems(@Param("avoidItemId")String avoidItemId, @Param("userId")Long userId,@Param("size")int itemSize);

	List<Map<String, Object>> findMapListUploadRanking();

	List<Map<String, Object>> findMapListAnswerRanking();

	List<Item> findByAuthorAndRelogItem(@Param("authorId")String authorId, @Param("itemId")String itemId);

	List<Item> searchItemByTitles(@Param("avoidItemId") String avoidItemId, @Param("titles")Collection<String> titles,
			@Param("page")Pageable pageable);

	List<Item> findByCategory(String categoryId);

	Long countReloggedTimes(String itemId);

	Long countAll();

	List<Item> findAllItemsBeforeMonths(@Param("inWeeks")Integer inWeeks, @Param("start")Date start, @Param("end")Date end, @Param("userId")String userId, @Param("page")PageRequest pageRequest);

	List<Item> findListByLocationForMyItem(@Param("userId")String userId, @Param("x1")Double x1, @Param("x2")Double x2,
			@Param("y1")Double y1, @Param("y2")Double y2, @Param("categoryIds")List<String> categoryIds);

	List<Item> findListByLocationNotForMyItem(@Param("userId")String userId, @Param("x1")Double x1, @Param("x2")Double x2,
			@Param("y1")Double y1, @Param("y2")Double y2, @Param("categoryIds")List<String> categoryIds);

	List<Item> findListByMD5(String md5);

	List<Item> findListForMyTimemap(String userId);

	List<Item> findListByImage(String image);

	List<Item> findListAll();

	List<Item> findListForImageQuizGenerate(@Param("userId")String userId, @Param("itemId")String itemId,
			@Param("fileType")String fileType, @Param("questiontypeId")Long questiontypeId, @Param("languageId")String languageId);

	List<Item> findListForTextQuizGenerate(@Param("itemId")String itemId, @Param("languageId")String languageId);

	List<Map<String, Object>> findMapListForToAnswerItem(@Param("page")PageRequest pageRequest);
	
	List<Item> findsearchRelatedItemForTask(@Param("taskId")String taskId, @Param("querystr")String querystr, @Param("limit")Integer limit);

	List<Item> findsearchRelatedItemForTask2(@Param("taskId")String taskId, @Param("querystr")String querystr, @Param("limit")Integer limit);

	List<Item> findItemListHasImage();
}
