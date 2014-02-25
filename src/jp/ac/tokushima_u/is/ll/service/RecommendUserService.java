package jp.ac.tokushima_u.is.ll.service;
//↑を消すとよい？


import java.util.ArrayList;
import java.util.List;

import jp.ac.tokushima_u.is.ll.dao.ItemDao;
import jp.ac.tokushima_u.is.ll.dao.LogUserReadItemDao;
import jp.ac.tokushima_u.is.ll.dao.MyQuizDao;
import jp.ac.tokushima_u.is.ll.dto.MyQuizDTO;
import jp.ac.tokushima_u.is.ll.entity.Item;
import jp.ac.tokushima_u.is.ll.entity.LogUserReadItem;
import jp.ac.tokushima_u.is.ll.entity.Users;
import jp.ac.tokushima_u.is.ll.service.helper.UserQuizInfo;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/*
 * 作成者:mizuura
//とりあえず作ってみた

//SettingServece.javaにとりこむといいかも
まだまだ作成中
*/

@Service("recommendUserService")
@Transactional(readOnly = true)
public class RecommendUserService {
    @Autowired
    private UserService userService;
    @Autowired
    private MyQuizDao myquizDao;
    @Autowired
    private ItemDao itemDao;
    @Autowired
    private LogUserReadItemDao logUserReadItemDao;

    public List<UserQuizInfo> searchAllUsersQuizInfo(){
    	List<Users> users = this.userService.searchAllUsers();
    	List<UserQuizInfo> infos = new ArrayList<UserQuizInfo>();
    	for(Users user:users){
    		UserQuizInfo info = new UserQuizInfo();
//    		String hql = "from MyQuiz myquiz where author=:author and answerstate = 1 and ( wrongtimes is null or wrongtimes < 1)";
//        	Map<String, Object> params = new HashMap<String, Object>();
//    		params.put("author", user);
    		List<MyQuizDTO> rightquizzes = this.myquizDao.findListRightQuizzes(user.getId());
//    		String hql1 = "from MyQuiz myquiz where author=:author and ( answerstate = 0 or wrongtimes > 0)";
    		List<MyQuizDTO> wrongquizzes = this.myquizDao.findListWrongQuizzes(user.getId());

    		Integer righttimes = 0;
    		if(rightquizzes!=null)
    			righttimes = rightquizzes.size();
    		Integer wrongtimes = 0;
    		if(wrongquizzes!=null)
    			wrongtimes = wrongquizzes.size();

    		Integer totaltimes = righttimes + wrongtimes;
    		double correctrate = 0; //正答率
    		if(totaltimes == 0){ //クイズもやったことがない人がいるときの処理(0で割らないように)
    			correctrate = -1;
    		}
    		else {
    			correctrate = righttimes * 100 / totaltimes;
    		}

//    		String hql_item = "from Item item where author=:author and relogItem is null";
    		List<Item> myitems = this.itemDao.findListByAuthorNotRelog(user.getId());

//    		String hql_relog = "from Item item where author=:author and relogItem is not null";
    		List<Item> myrelogs = this.itemDao.findListByAuthorOnlyRelog(user.getId());
    		if(myitems!=null)
    			info.setUploadnumber(myitems.size());

    		if(myrelogs!=null)
    			info.setRelognumber(myrelogs.size());

//    		String hql_read = "from LogUserReadItem readitem where readitem.user=:author";
//    		Map<String, Object> tempparams = new HashMap<String, Object>();
//    		tempparams.put("author", user);
    		List<LogUserReadItem> readitems =  this.logUserReadItemDao.findListByUserId(user.getId());
    		info.setReferencenumber(readitems.size());

//    		String hql_myread = "from LogUserReadItem readitem where readitem.user=:author and readitem.item.author=:author";
//    		tempparams.put("author", user);
    		List<LogUserReadItem> myreaditems =  this.logUserReadItemDao.findListByUserIdSelfRead(user.getId());
    		info.setMyreferencenumber(myreaditems.size());

    		info.setUser(user);
    		info.setWrongtimes(wrongtimes);
    		info.setRighttimes(righttimes);
//    		info.setCorrectrate(correctrate);
    		if(correctrate>=50) {
    			infos.add(info);
    		}
    	}
   // 	Collections.sort(infos);
    	return infos;
    }


	/*
    private HibernateDao<Category, String> categoryDao;
	public List<Category> testForm(SettingForm form) {

        if(form.getCategoryIdList()==null){
       	 form.setCategoryIdList(new ArrayList<String>());
        }

		List<Category> myCategoryList = new ArrayList<Category>();
		for(String categoryId: form.getCategoryIdList()){
			myCategoryList.add(categoryDao.get(categoryId));
        }
		//myCategoryListの使い方を聞く

		return(myCategoryList);
	}
	*/

}